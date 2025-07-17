provider "aws" {
  region = "us-east-1"
}
module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

module "ec2_proxy" {
  source           = "./modules/ec2_proxy"
  subnet_ids       = module.network.public_subnets
  sg_id            = module.security.proxy_sg_id
  ami_id           = data.aws_ami.amazon_linux.id
  private_key_path = "/home/youssef/terraform-secure-web-app/my-key.pem"
  key_name         = "my-key"
  user_data_path   = "${path.module}/install_proxy.sh"
  backend_url            = "http://${module.load_balancer.internal_alb_dns}"
}

module "ec2_backend" {
  source           = "./modules/ec2_backend"
  subnet_ids       = module.network.private_subnets
  sg_id            = module.security.backend_sg_id
  ami_id           = data.aws_ami.amazon_linux.id
  private_key_path = "/home/youssef/terraform-secure-web-app/my-key.pem"
  key_name         = "my-key"
  user_data_path   = "${path.module}/install_backend.sh"
  bastion_host       = module.ec2_proxy.public_ips[0] 
}

module "load_balancer" {
  source               = "./modules/load_balancer"
  vpc_id               = module.network.vpc_id
  public_subnets       = module.network.public_subnets
  private_subnets      = module.network.private_subnets
  proxy_instance_ids   = module.ec2_proxy.instance_ids
  backend_instance_ids = module.ec2_backend.instance_ids
  sg_alb_id            = module.security.alb_sg_id
}

resource "null_resource" "generate_ips_file" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Proxy IPs: ${join(", ", module.ec2_proxy.public_ips)}" > all-ips.txt
      echo "Backend IPs: ${join(", ", module.ec2_backend.private_ips)}" >> all-ips.txt
    EOT
  }
}

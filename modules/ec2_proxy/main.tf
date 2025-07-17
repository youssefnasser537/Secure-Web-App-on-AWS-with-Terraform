data "template_file" "proxy_script" {
  template = file("${path.root}/install_proxy.sh")
vars = {
    backend_url = var.backend_url
  }
}

resource "aws_instance" "proxy" {
  count                         = 2
  ami                           = var.ami_id
  instance_type                 = "t2.micro"
  key_name                      = var.key_name
  subnet_id                     = var.subnet_ids[count.index]
  vpc_security_group_ids        = [var.sg_id]
  associate_public_ip_address   = true

  tags = {
    Name = "Proxy-Instance-${count.index}"
  }

  provisioner "file" {
    source = data.template_file.proxy_script.rendered
    destination = "/tmp/proxy.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
      timeout     = "5m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/proxy.sh",
      "bash /tmp/proxy.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
      timeout     = "5m"
    }
  }
}

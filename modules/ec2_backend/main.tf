resource "aws_instance" "backend" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = false

  tags = {
    Name = "Backend-Instance-${count.index}"
  }

  provisioner "file" {
    source      = var.user_data_path
    destination = "/tmp/backend.sh"

    connection {
      type                = "ssh"
      user                = "ec2-user"
      private_key         = file(var.private_key_path)
      host                = self.private_ip
      bastion_host        = var.bastion_host
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "bash /tmp/backend.sh"
    ]

    connection {
      type                = "ssh"
      user                = "ec2-user"
      private_key         = file(var.private_key_path)
      host                = self.private_ip
      bastion_host        = var.bastion_host
      bastion_user        = "ec2-user"
      bastion_private_key = file(var.private_key_path)
    }
  }
}

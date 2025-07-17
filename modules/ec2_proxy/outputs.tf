output "public_ips" {
  value = aws_instance.proxy[*].public_ip
}

output "instance_ids" {
  value = aws_instance.proxy[*].id
}

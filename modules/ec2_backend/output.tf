output "private_ips" {
  value = aws_instance.backend[*].private_ip
}

output "instance_ids" {
  value = aws_instance.backend[*].id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "proxy_sg_id" {
  value = aws_security_group.proxy_sg.id
}

output "backend_sg_id" {
  value = aws_security_group.backend_sg.id
}

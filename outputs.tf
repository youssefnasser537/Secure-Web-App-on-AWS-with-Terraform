output "public_alb_dns" {
  value = module.load_balancer.public_alb_dns
}

output "internal_alb_dns" {
  value = module.load_balancer.internal_alb_dns
}

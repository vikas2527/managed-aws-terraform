output "alb_arn" {
  description = "Prod ALB ARN"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "Prod ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Prod ALB zone ID for Route53"
  value       = module.alb.alb_zone_id
}

output "alb_security_group_id" {
  description = "Prod ALB security group ID"
  value       = module.alb.alb_security_group_id
}

output "http_listener_arn" {
  description = "Prod ALB HTTP listener ARN"
  value       = module.alb.http_listener_arn
}

output "https_listener_arn" {
  description = "Prod ALB HTTPS listener ARN"
  value       = module.alb.https_listener_arn
}
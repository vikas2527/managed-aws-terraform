output "vpc_id" {
  description = "Prod VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "Prod VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Prod VPC public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Prod VPC private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "Prod VPC NAT gateway ID"
  value       = module.vpc.nat_gateway_id
}
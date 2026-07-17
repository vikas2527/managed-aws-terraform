output "vpc_id" {
  description = "Shared VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "Shared VPC CIDR"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Shared VPC public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Shared VPC private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "Shared VPC NAT gateway ID"
  value       = module.vpc.nat_gateway_id
}
output "db_instance_id" {
  description = "Prod RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_host" {
  description = "Prod RDS hostname"
  value       = module.rds.db_host
}

output "db_port" {
  description = "Prod RDS port"
  value       = module.rds.db_port
}

output "db_name" {
  description = "Prod database name"
  value       = module.rds.db_name
}

output "db_endpoint" {
  description = "Prod RDS endpoint"
  value       = module.rds.db_endpoint
}

output "db_security_group_id" {
  description = "Prod RDS security group ID"
  value       = module.rds.db_security_group_id
}
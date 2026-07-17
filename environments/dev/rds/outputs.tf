output "db_instance_id" {
  description = "Dev RDS instance ID"
  value       = module.rds.db_instance_id
}

output "db_host" {
  description = "Dev RDS hostname"
  value       = module.rds.db_host
}

output "db_port" {
  description = "Dev RDS port"
  value       = module.rds.db_port
}

output "db_name" {
  description = "Dev database name"
  value       = module.rds.db_name
}

output "db_endpoint" {
  description = "Dev RDS endpoint"
  value       = module.rds.db_endpoint
}

output "db_security_group_id" {
  description = "Dev RDS security group ID"
  value       = module.rds.db_security_group_id
}
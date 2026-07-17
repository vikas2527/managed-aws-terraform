output "instance_id" {
  description = "Devtools EC2 instance ID"
  value       = module.devtools.instance_id
}

output "private_ip" {
  description = "Devtools private IP — access via VPN then SSH"
  value       = module.devtools.private_ip
}

output "security_group_id" {
  description = "Devtools security group ID"
  value       = module.devtools.security_group_id
}

output "iam_role_name" {
  description = "Devtools IAM role name"
  value       = module.devtools.iam_role_name
}
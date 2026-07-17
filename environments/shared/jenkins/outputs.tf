output "instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.jenkins.instance_id
}

output "private_ip" {
  description = "Jenkins private IP — access via VPN"
  value       = module.jenkins.private_ip
}

output "security_group_id" {
  description = "Jenkins security group ID"
  value       = module.jenkins.security_group_id
}

output "iam_role_name" {
  description = "Jenkins IAM role name"
  value       = module.jenkins.iam_role_name
}
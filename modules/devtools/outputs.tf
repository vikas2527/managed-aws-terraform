output "instance_id" {
  description = "Devtools EC2 instance ID"
  value       = aws_instance.devtools.id
}

output "private_ip" {
  description = "Devtools EC2 private IP address"
  value       = aws_instance.devtools.private_ip
}

output "security_group_id" {
  description = "Devtools security group ID"
  value       = aws_security_group.devtools.id
}

output "iam_role_name" {
  description = "Devtools IAM role name"
  value       = aws_iam_role.devtools.name
}

output "iam_role_arn" {
  description = "Devtools IAM role ARN"
  value       = aws_iam_role.devtools.arn
}
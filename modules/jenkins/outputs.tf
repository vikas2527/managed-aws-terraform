output "instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "private_ip" {
  description = "Jenkins EC2 private IP address"
  value       = aws_instance.jenkins.private_ip
}

output "security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}

output "iam_role_name" {
  description = "Jenkins IAM role name"
  value       = aws_iam_role.jenkins.name
}

output "iam_role_arn" {
  description = "Jenkins IAM role ARN"
  value       = aws_iam_role.jenkins.arn
}
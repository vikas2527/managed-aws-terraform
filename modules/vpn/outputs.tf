output "instance_id" {
  description = "VPN EC2 instance ID"
  value       = aws_instance.vpn.id
}

output "public_ip" {
  description = "VPN EC2 public IP — developers connect to this"
  value       = aws_instance.vpn.public_ip
}

output "private_ip" {
  description = "VPN EC2 private IP"
  value       = aws_instance.vpn.private_ip
}

output "security_group_id" {
  description = "VPN security group ID"
  value       = aws_security_group.vpn.id
}

output "vpn_cidr" {
  description = "VPN tunnel network CIDR"
  value       = var.vpn_cidr
}
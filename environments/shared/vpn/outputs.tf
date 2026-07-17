output "instance_id" {
  description = "VPN EC2 instance ID"
  value       = module.vpn.instance_id
}

output "public_ip" {
  description = "VPN public IP — developers connect to this"
  value       = module.vpn.public_ip
}

output "private_ip" {
  description = "VPN private IP"
  value       = module.vpn.private_ip
}

output "security_group_id" {
  description = "VPN security group ID"
  value       = module.vpn.security_group_id
}

output "vpn_cidr" {
  description = "VPN tunnel network CIDR"
  value       = module.vpn.vpn_cidr
}
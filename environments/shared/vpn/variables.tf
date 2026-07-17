variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "Shared VPC ID — from shared/vpc outputs"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID — from shared/vpc outputs"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID for VPN EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for VPN"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "vpn_cidr" {
  description = "VPN tunnel network CIDR"
  type        = string
  default     = "10.8.0.0/24"
}

variable "vpc_cidr" {
  description = "Shared VPC CIDR — pushed to VPN clients"
  type        = string
}

variable "dev_vpc_cidr" {
  description = "Dev VPC CIDR — pushed to VPN clients"
  type        = string
}

variable "prod_vpc_cidr" {
  description = "Prod VPC CIDR — pushed to VPN clients"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
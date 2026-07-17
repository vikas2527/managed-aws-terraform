variable "project_name" {
  description = "Project name used as a naming prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where VPN will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for VPN EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for VPN EC2 instance"
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
  description = "CIDR of the shared VPC — pushed to VPN clients"
  type        = string
}

variable "dev_vpc_cidr" {
  description = "CIDR of the dev VPC — pushed to VPN clients"
  type        = string
}

variable "prod_vpc_cidr" {
  description = "CIDR of the prod VPC — pushed to VPN clients"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
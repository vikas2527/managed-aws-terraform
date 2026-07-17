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

variable "subnet_id" {
  description = "Private subnet ID — from shared/vpc outputs"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID for devtools EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for devtools"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "vpn_cidr" {
  description = "VPN tunnel CIDR — only source allowed to access devtools"
  type        = string
  default     = "10.8.0.0/24"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
}

variable "eks_cluster_names" {
  description = "EKS cluster names to configure kubectl for"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
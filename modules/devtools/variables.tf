variable "project_name" {
  description = "Project name used as a naming prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where devtools will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID for devtools EC2"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for devtools EC2 instance"
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
  description = "VPN CIDR block — only source allowed to access devtools"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
}

variable "eks_cluster_names" {
  description = "List of EKS cluster names devtools needs access to"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
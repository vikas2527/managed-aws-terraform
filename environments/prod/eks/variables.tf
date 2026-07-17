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
  description = "Prod VPC ID — from prod/vpc outputs"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs — from prod/vpc outputs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs — from prod/vpc outputs"
  type        = list(string)
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "EC2 instance types for node group"
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 10
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  type        = number
  default     = 100
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach EKS API — VPN CIDR"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
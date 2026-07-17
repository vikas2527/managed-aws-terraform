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
  description = "Dev VPC ID — from dev/vpc outputs"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs — from dev/vpc outputs"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "EKS node security group ID — from dev/eks outputs"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "VPN CIDR — for psql access from devtools"
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage in GB"
  type        = number
  default     = 50
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "15.4"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
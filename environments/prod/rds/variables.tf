variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "allowed_security_group_ids" {
  type    = list(string)
  default = []
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID auto-created by EKS"
  type        = string
  default     = ""
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.large"
}

variable "allocated_storage" {
  type    = number
  default = 100
}

variable "max_allocated_storage" {
  type    = number
  default = 500
}

variable "postgres_version" {
  type    = string
  default = "15.4"
}

variable "tags" {
  type    = map(string)
  default = {}
}
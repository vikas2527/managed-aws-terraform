variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

# ── Shared VPC ────────────────────────────────────────────────────────────────
variable "shared_vpc_id" {
  description = "Shared VPC ID — from shared/vpc outputs"
  type        = string
}

variable "shared_vpc_cidr" {
  description = "Shared VPC CIDR — from shared/vpc outputs"
  type        = string
}

variable "shared_private_route_table_id" {
  description = "Shared VPC private route table ID — from shared/vpc outputs"
  type        = string
}

# ── Dev VPC ───────────────────────────────────────────────────────────────────
variable "dev_vpc_id" {
  description = "Dev VPC ID — from dev/vpc outputs"
  type        = string
}

variable "dev_vpc_cidr" {
  description = "Dev VPC CIDR — from dev/vpc outputs"
  type        = string
}

variable "dev_private_route_table_id" {
  description = "Dev VPC private route table ID — from dev/vpc outputs"
  type        = string
}

# ── Prod VPC ──────────────────────────────────────────────────────────────────
variable "prod_vpc_id" {
  description = "Prod VPC ID — from prod/vpc outputs"
  type        = string
}

variable "prod_vpc_cidr" {
  description = "Prod VPC CIDR — from prod/vpc outputs"
  type        = string
}

variable "prod_private_route_table_id" {
  description = "Prod VPC private route table ID — from prod/vpc outputs"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
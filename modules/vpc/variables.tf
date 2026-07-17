variable "project_name" {
    description = "Project name used as a naming prefix"
    type        = string
}

variable "environment" {
    description = "Deployment environment"
    type = string

    validation {
      condition = contains(["dev", "prod", "shared"], var.enviornment)
      error_message = "environment must be one of: dev, prod, shared"
    }
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "tags" {
    description = "additional tags to apply on resources"
    type = map(string)
    default = {}
}
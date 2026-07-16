variable "aws_region" {
    description = "AWS region"
    type = string
}

variable "project_name" {
  description = "project name"
  type = string
}

variable "vpc_id" {
  description = "VPC ID where Jenkins will be launched"
  type = string
}

variable "subnet_id" {
  description = "public_subnet id"
  type = string
}

variable "ami_id" {
    description = "AMI ID for jenkins instance"
    type = string
}

variable "instance_type" {
    description = "EC2 instance type for jenkins"
    type = string
    default = "c7i-flex.large"
}

variable "key_name" {
    description = "name of key pair"
    type        = string 
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 100
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into Jenkins"
  type        = list(string)
}

variable "allowed_ui_cidrs" {
  description = "CIDR blocks allowed to access Jenkins UI on port 8080"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
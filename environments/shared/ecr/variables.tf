variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "Image tag mutability"
  type        = string
  default     = "MUTABLE"
}

variable "max_image_count" {
  description = "Maximum number of images to retain"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
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

variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 10
}

variable "node_disk_size" {
  type    = number
  default = 100
}

variable "allowed_cidr_blocks" {
  type = list(string)
}

variable "devtools_role_arn" {
  type = string
}

variable "jenkins_role_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
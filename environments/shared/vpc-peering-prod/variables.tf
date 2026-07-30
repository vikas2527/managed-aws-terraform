variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "project_name" {
  type = string
}

variable "shared_vpc_id" {
  type = string
}

variable "shared_vpc_cidr" {
  type = string
}

variable "shared_private_route_table_id" {
  type = string
}

variable "shared_public_route_table_id" {
  type = string
}

variable "prod_vpc_id" {
  type = string
}

variable "prod_vpc_cidr" {
  type = string
}

variable "prod_private_route_table_id" {
  type = string
}

variable "prod_public_route_table_id" {
  type = string
}

variable "vpn_cidr" {
  type    = string
  default = "10.8.0.0/24"
}

variable "tags" {
  type    = map(string)
  default = {}
}
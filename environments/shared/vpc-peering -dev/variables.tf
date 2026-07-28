variable "aws_region"                   { type = string; default = "us-west-1" }
variable "project_name"                 { type = string }
variable "shared_vpc_id"                { type = string }
variable "shared_vpc_cidr"              { type = string }
variable "shared_private_route_table_id" { type = string }
variable "dev_vpc_id"                   { type = string }
variable "dev_vpc_cidr"                 { type = string }
variable "dev_private_route_table_id"   { type = string }
variable "tags"                         { type = map(string); default = {} }
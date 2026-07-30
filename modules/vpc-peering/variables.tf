variable "project_name" {
  description = "Project name used as a naming prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment label for naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the requester VPC (shared VPC)"
  type        = string
}

variable "peer_vpc_id" {
  description = "ID of the accepter VPC (dev or prod VPC)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the requester VPC (shared VPC)"
  type        = string
}

variable "peer_vpc_cidr" {
  description = "CIDR block of the accepter VPC (dev or prod VPC)"
  type        = string
}

variable "vpc_route_table_id" {
  description = "Route table ID of the shared VPC private subnets"
  type        = string
}

variable "peer_route_table_id" {
  description = "Route table ID of the peer VPC private subnets"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpn_cidr" {
  description = "VPN tunnel CIDR to add routes for"
  type        = string
  default     = ""
}

variable "peer_public_route_table_id" {
  description = "Public route table ID of the peer VPC"
  type        = string
  default     = ""
}

variable "vpc_public_route_table_id" {
  description = "Public route table ID of the shared VPC"
  type        = string
  default     = ""
}

variable "add_vpn_route_to_shared" {
  description = "Whether to add VPN route to shared VPC route table — skip if already exists"
  type        = bool
  default     = true
}
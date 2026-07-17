variable "project_name" {
    description = "project name used as a naming prefix"
    type = string
}

variable "environment" {
  description = "Deployment environment"
  type = string
}

variable "vpc_id" {
    description = "VPC ID where the EKS cluster will be deployed"
    type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS node groups"
  type        = list(string)
}

variable "public_subnet_ids" {
    description = "Public subnet IDs for EKS control plane ENIs"
    type        = list(string)
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "node_disk_size" {
  description = "Disk size in GB for worker nodes"
  type        = number
  default     = 50
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the EKS API server (VPN CIDR)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
output "cluster_name" {
  description = "Dev EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Dev EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Dev EKS cluster CA certificate"
  value       = module.eks.cluster_ca_certificate
}

output "oidc_provider_arn" {
  description = "Dev EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "Dev EKS OIDC provider URL"
  value       = module.eks.oidc_provider_url
}

output "cluster_security_group_id" {
  description = "Dev EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Dev EKS node security group ID"
  value       = module.eks.node_security_group_id
}
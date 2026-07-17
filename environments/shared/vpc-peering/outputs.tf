output "shared_dev_peering_id" {
  description = "Shared ↔ Dev peering connection ID"
  value       = module.peering_shared_dev.peering_connection_id
}

output "shared_dev_peering_status" {
  description = "Shared ↔ Dev peering connection status"
  value       = module.peering_shared_dev.peering_connection_status
}

output "shared_prod_peering_id" {
  description = "Shared ↔ Prod peering connection ID"
  value       = module.peering_shared_prod.peering_connection_id
}

output "shared_prod_peering_status" {
  description = "Shared ↔ Prod peering connection status"
  value       = module.peering_shared_prod.peering_connection_status
}
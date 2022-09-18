output "ids" {
  description = "List of IDs of Customer Gateway"
  value       = module.cgw.ids
}

output "customer_gateway" {
  description = "Map of Customer Gateway attributes"
  value       = module.cgw.customer_gateway
}
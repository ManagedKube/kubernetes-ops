output "project_id" {
  description = "The id of the project"
  value       = module.id
}

output "project_owner_uuid" {
  description = "the unique universal identifier of the project owner."
  value       = module.owner_uuid
}
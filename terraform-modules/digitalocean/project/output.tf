output "project_id" {
  description = "The id of the project"
  value       = this.id
}

output "project_owner_uuid" {
  description = "the unique universal identifier of the project owner."
  value       = this.owner_uuid
}
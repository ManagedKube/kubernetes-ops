output "project_id" {
  description = "The id of the project"
  value       = digitalocean_project.this.id
}

output "project_owner_uuid" {
  description = "The unique universal identifier of the project owner."
  value       = digitalocean_project.this.owner_uuid
}

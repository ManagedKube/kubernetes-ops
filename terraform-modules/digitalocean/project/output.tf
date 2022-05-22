output "project_id" {
  description = "The id of the project"
  value       = digitalocean_project.project.id
}

output "project_owner_uuid" {
  description = "the unique universal identifier of the project owner."
  value       = digitalocean_project.project.owner_uuid
}

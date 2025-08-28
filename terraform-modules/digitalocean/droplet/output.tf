output "droplet_id" {
  description = "The ID of the Droplet"
  value       = digitalocean_droplet.this.id
}
output "droplet_urn" {
  description = "The uniform resource name of the Droplet"
  value       = digitalocean_droplet.this.urn
}
output "volume_id" {
  description = "The unique identifier for the volume."
  value       = digitalocean_volume.this.id
}
output "volume_urn" {
  description = "The uniform resource name for the volume."
  value       = digitalocean_volume.this.urn
}
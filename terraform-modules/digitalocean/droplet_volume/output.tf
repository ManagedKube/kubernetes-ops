output "droplet_volume_attachment" {
  description = "The unique identifier for the volume attachment."
  value       = digitalocean_volume_attachment.this.id
}
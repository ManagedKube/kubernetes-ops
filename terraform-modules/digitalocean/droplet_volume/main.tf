terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}

resource "digitalocean_volume_attachment" "this" {
  droplet_id = var.droplet_id
  volume_id  = var.volume_id
}
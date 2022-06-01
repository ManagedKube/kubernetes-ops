terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}

resource "digitalocean_volume" "this" {
  region                  = var.volume_region
  name                    = var.volume_name
  size                    = var.volume_size
  initial_filesystem_type = var.volume_initial_filesystem_type
  description             = var.volume_description
}
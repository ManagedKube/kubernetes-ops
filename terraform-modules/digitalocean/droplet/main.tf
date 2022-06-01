terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}

resource "digitalocean_droplet" "this" {
  image       = var.droplet_image
  name        = var.droplet_name
  region      = var.droplet_region
  size        = var.droplet_size
  monitoring  = var.droplet_monitoring
  vpc_uuid    = var.droplet_vpc_uuid
}
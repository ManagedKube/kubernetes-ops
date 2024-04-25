terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}
#Create vpc in digital ocean
resource "digitalocean_vpc" "this" {
  name        = var.vpc_name
  description = var.vpc_description
  region      = var.vpc_region
  ip_range    = var.vpc_ip_range
}


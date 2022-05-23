terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
resource "digitalocean_project" "project" {
  name        = var.name
  description = var.description
  purpose     = var.purpose
  environment = var.environment
}
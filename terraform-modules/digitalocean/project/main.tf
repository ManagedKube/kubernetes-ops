terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
  }
}
resource "digitalocean_project" "project" {
  project_name        = var.name
  project_description = var.description
  project_purpose     = var.purpose
  project_environment = var.environment
}
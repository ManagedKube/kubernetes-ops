terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "do_token" {}

provider "digitalocean" {
  token = "dop_v1_76205feb4816c770ae08504abb51a02458366d3ed0a968b6fad57b1e64a501d0"
}
resource "digitalocean_project" "project" {
  name        = var.name
  description = var.description
  purpose     = var.purpose
  environment = var.environment
}
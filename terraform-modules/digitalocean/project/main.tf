terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "do_token" {}
variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}
data "digitalocean_ssh_key" "terraform" {
  name = "digitalocean"
}

resource "digitalocean_project" "project" {
  name        = var.name
  description = var.description
  purpose     = var.purpose
  environment = var.environment
}
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
  token = "dop_v1_f06110b92b2c712c88467b0982daef5f11b80eff9ce1bc612ab5e3cda3b3a84c"
}
data "digitalocean_ssh_key" "terraform" {
  name = "46:6e:72:9e:9e:48:8c:cf:df:9b:b7:f7:a2:89:28:3c"
}

resource "digitalocean_project" "project" {
  name        = var.name
  description = var.description
  purpose     = var.purpose
  environment = var.environment
}
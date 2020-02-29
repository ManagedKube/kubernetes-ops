terraform {
  backend "gcs" {
  }
}

provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> v3.10.0"
}

data "google_compute_network" "main-network" {
  name = var.vpc_name
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.network_name}-gke-private-subnet"
  ip_cidr_range            = var.private_subnet_cidr_range
  network                  = data.google_compute_network.main-network.self_link
  region                   = var.region
  private_ip_google_access = "true"

  # enable secondary IP range for pods and services:
  secondary_ip_range {
    range_name    = "${var.network_name}-gke-pods"
    ip_cidr_range = var.pods_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = "${var.network_name}-gke-services"
    ip_cidr_range = var.services_ip_cidr_range
  }
}

resource "google_compute_subnetwork" "public_subnet" {
  name                     = "${var.network_name}-gke-public-subnet"
  ip_cidr_range            = var.public_subnet_cidr_range
  network                  = data.google_compute_network.main-network.self_link
  region                   = var.region
  private_ip_google_access = "true"
}

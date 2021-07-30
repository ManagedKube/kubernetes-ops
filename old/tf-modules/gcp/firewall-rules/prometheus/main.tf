terraform {
  backend "gcs" {}
}

provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> 2.10.0"
}

resource "google_compute_firewall" "default" {
  name    = "prometheus-adapter"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["6443", "8443"]
  }

  source_ranges = var.source_range_list
}

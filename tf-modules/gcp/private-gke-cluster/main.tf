terraform {
  backend "s3" {
  }
}

provider "google" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> 2.10.0"
}

provider "google-beta" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> 2.10.0"
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.network_name}-gke-private-subnet"
  ip_cidr_range            = var.private_subnet_cidr_range
  network                  = var.vpc_name
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
  network                  = var.vpc_name
  region                   = var.region
  private_ip_google_access = "true"
}

resource "google_container_cluster" "primary" {
  provider           = google-beta
  name               = var.cluster_name
  location           = var.region
  node_version       = var.node_version
  min_master_version = var.node_version
  network            = var.network_name
  subnetwork         = google_compute_subnetwork.private_subnet.name
  initial_node_count = var.initial_node_count

  # set private cluster properties
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_kube_master_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # RFC 1918 private network
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_cidr
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = lookup(cidr_blocks.value, "display_name", null)
      }
    }
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # private clusters require secondary address ranges
  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.network_name}-gke-pods"
    services_secondary_range_name = "${var.network_name}-gke-services"
  }

  # enable network policy and a provider
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  enable_legacy_abac = false

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing
    }

    # disable the  k8s dashboard as it is insecure
    kubernetes_dashboard {
      disabled = true
    }
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  depends_on = [google_compute_subnetwork.private_subnet]
}

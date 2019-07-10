terraform {
  backend "s3" {}
}

provider "google" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 0.1.3"
}

provider "google-beta" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 1.20"
}

# resource "google_compute_network" "main" {
#   name                    = "${var.vpc_name}"
#   auto_create_subnetworks = "false"
# }

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.network_name}-gke-private-subnet"
  ip_cidr_range            = "${var.private_subnet_cidr_range}"
  network                  = "${var.vpc_name}"
  region                   = "${var.region}"
  private_ip_google_access = "true"

  # enable secondary IP range for pods and services:
  secondary_ip_range = [
    {
      range_name    = "${var.network_name}-gke-pods"
      ip_cidr_range = "${var.pods_ip_cidr_range}"
    },
    {
      range_name    = "${var.network_name}-gke-services"
      ip_cidr_range = "${var.services_ip_cidr_range}"
    },
  ]
}

resource "google_compute_subnetwork" "public_subnet" {
  name                     = "${var.network_name}-gke-public-subnet"
  ip_cidr_range            = "${var.public_subnet_cidr_range}"
  network                  = "${var.vpc_name}"
  region                   = "${var.region}"
  private_ip_google_access = "true"
}

resource "google_container_cluster" "primary" {
  provider           = "google-beta"
  name               = "${var.cluster_name}"
  zone               = "${var.region_zone}"
  node_version       = "${var.node_version}"
  min_master_version = "${var.node_version}"
  network            = "${var.network_name}"
  subnetwork         = "${var.subnetwork}"
  initial_node_count = "${var.initial_node_count}"

  # set private cluster properties
  private_cluster_config {
    enable_private_nodes    = "${var.enable_private_nodes}"
    enable_private_endpoint = "${var.enable_private_kube_master_endpoint}"
    master_ipv4_cidr_block  = "${var.master_ipv4_cidr_block}"
  }

  # RFC 1918 private network
  master_authorized_networks_config {
    cidr_blocks = "${var.master_authorized_networks_cidr}"
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

  addons_config {
    http_load_balancing {
      disabled = "${var.http_load_balancing}"
    }

    # disable the  k8s dashboard as it is insecure
    kubernetes_dashboard {
      disabled = true
    }
  }

  # node_config {
  #   oauth_scopes = "${var.oauth_scopes}"
  #   labels       = "${var.labels}"
  #   tags         = "${var.tags}"
  #   machine_type = "${var.machine_type}"
  #   disk_size_gb = "${var.disk_size_gb}"
  #   image_type   = "${var.image_type}"
  # }
}

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name       = "my-node-pool"
#   location   = "us-central1"
#   cluster    = "${google_container_cluster.primary.name}"
#   node_count = 1
#
#   node_config {
#     preemptible  = true
#     machine_type = "n1-standard-1"
#
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#   }
# }

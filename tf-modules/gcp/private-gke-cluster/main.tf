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

provider "google-beta" {
  region      = var.region
  project     = var.project_name
  credentials = file(var.credentials_file_path)
  version     = "~> v3.10.0"
}

resource "google_container_cluster" "primary" {
  provider           = google-beta
  name               = var.cluster_name
  location           = var.region
  node_version       = var.gke_version
  min_master_version = var.gke_version
  network            = var.network_name
  subnetwork         = var.private_subnet_name
  initial_node_count = var.initial_node_count

  authenticator_groups_config {
    security_group = var.authenticator_groups_config
  }

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
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

    cluster_autoscaling {

      enabled = var.cluster_autoscaling_enabled

      dynamic "resource_limits" {
        for_each = var.resource_limits_enable
        content {
          resource_type = resource_limits.value["type"]
          minimum       = resource_limits.value["min"]
          maximum       = resource_limits.value["max"]
        }
      }

      auto_provisioning_defaults {
        oauth_scopes = var.cluster_autoscaling_auto_provisioning_defaults_oauth_scopes
        service_account = var.cluster_autoscaling_auto_provisioning_defaults_service_account
      }

      autoscaling_profile = var.cluster_autoscaling_autoscaling_profile

  }

}

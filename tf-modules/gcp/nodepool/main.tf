terraform {
  backend "s3" {}
}

provider "google-beta" {
  region      = "${var.region}"
  project     = "${var.project_name}"
  credentials = "${file("${var.credentials_file_path}")}"
  version     = "~> 2.10.0"
}

resource "google_container_node_pool" "node_nodes" {
  provider = "google-beta"
  name       = "${var.node_pool_name}"
  location   = "${var.region}"
  cluster    = "${var.cluster_name}"
  node_count = "${var.initial_node_count}"
  autoscaling = {
    min_node_count = "${var.min_node_count}"
    max_node_count = "${var.max_node_count}"
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }

  node_config {
    preemptible  = "${var.is_preemtible}"
    machine_type = "${var.machine_type}"

    disk_size_gb = "${var.disk_size_gb}"
    disk_type = "${var.disk_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = "${var.oauth_scopes}"

    labels = "${var.labels}"

    tags = "${var.tags}"

    taint = "${var.taints}"

  }
}

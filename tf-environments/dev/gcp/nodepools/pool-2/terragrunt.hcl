include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/gcp/nodepool/"
}

inputs = {

  cluster_name = "dev"
  node_pool_name = "pool-2"

  initial_node_count = "1"
  is_preemtible = true
  min_node_count = "0"
  max_node_count = "6"
  machine_type = "n1-standard-8"
  disk_size_gb = "100"

  image_type = "COS"

  # These represent the "gke-defaults" scope list
  oauth_scopes = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]

  # Kubernetes node labels
  labels = {}
  // {
  //   foo = "bar",
  //   foo2 = "bar2",
  // }

  # GCP node labels and firewall labels
  tags = []
  // ["foo", "bar"]

  # Kubernetes taints
  taints = []
  // [
  //   {
  //     effect = "NO_SCHEDULE"
  //     key    = "bar"
  //     value  = "foo"
  //   },
  //   {
  //     effect = "NO_SCHEDULE"
  //     key    = "bar2"
  //     value  = "foo2"
  //   },
  // ]

}

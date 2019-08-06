terragrunt = {
  terraform {
    source = "../../../../../tf-modules/gcp/nodepool/"
  }
  include {
    path = "${find_in_parent_folders()}"
  }
}

region = "us-central1"
project_name = "managedkube"
cluster_name = "dev"
node_pool_name = "pool-1"

initial_node_count = "1"
min_node_count = "0"
max_node_count = "3"
machine_type = "n1-standard-1"
disk_size_gb = "10"

image_type = "COS"

oauth_scopes = [
  "https://www.googleapis.com/auth/monitoring",
  "https://www.googleapis.com/auth/logging.write",
]

tags = [
  "private-subnet"
]

labels = {
}

taints = []

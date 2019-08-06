include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/private-gke-cluster/"
}

inputs = {
  network_name = "dev"
  cluster_name = "dev"

  enable_private_kube_master_endpoint = false

  oauth_scopes = [
    "compute-rw",
    "storage-rw",
    "logging-write",
    "monitoring"
  ]

  tags = ["dev"]

  labels = {}

  taints = []

  node_version = "1.12.8-gke.10"
  machine_type = "n1-standard-4"
  image_type = "COS"
  subnetwork = "dev-gke-private-subnet"
  disk_size_gb = "20"
  initial_node_count = "1"

  master_ipv4_cidr_block="10.20.22.0/28"

  pods_ip_cidr_range="10.20.64.0/19"
  services_ip_cidr_range="10.20.96.0/19"

  master_authorized_networks_cidr = [
    { cidr_block = "10.0.0.0/8", display_name = "10x" },
    { cidr_block = "172.16.0.0/12", display_name = "172x" },
    { cidr_block = "192.168.0.0/16", display_name = "192x" },
  ]


  #####################
  # networking
  #####################
  public_subnet_cidr_range = "10.20.11.0/24"
  private_subnet_cidr_range = "10.20.21.0/24"

  outbound_through_nat_tags=["private-subnet", "gke-private-nodes"]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/private-gke-cluster/"
}

inputs = {
  vpc_name = "dev"
  network_name = "dev"
  cluster_name = "dev"
  # private_subnet_name = "dev-gke-private-subnet"
  private_subnet_name = trimspace(run_cmd("terragrunt", "output", "private_subnet_name", "--terragrunt-working-dir", "../gke-subnets"))

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

  node_version = "1.14.10-gke.17"
  machine_type = "n1-standard-1"
  image_type = "COS"
  disk_size_gb = "20"
  initial_node_count = "1"

  master_ipv4_cidr_block="10.32.11.0/28"

  master_authorized_networks_cidr = [
    { cidr_block = "10.0.0.0/8", display_name = "10x" },
    { cidr_block = "172.16.0.0/12", display_name = "172x" },
    { cidr_block = "192.168.0.0/16", display_name = "192x" },
    { cidr_block = "38.30.8.138/32", display_name = "home" },
    { cidr_block = "35.222.67.76/32", display_name = "gar-vpn" },
  ]

  outbound_through_nat_tags=["private-subnet", "gke-private-nodes"]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//tf-modules/azure/aks/cluster/?ref=v0.1.23"
}

inputs = {
  cluster_name = "dev"
  location = "eastus2"
  dns_prefix = "dev"

  default_node_pool_instance_size = "Standard_B2s"

  api_server_authorized_ip_ranges = [    
    "38.30.0.0/8",
    "136.24.0.0/8",
  ]

  tags = {
    Environment     = "dev",
    Account         = "dev",
    Group           = "devops",
    Location        = "eastus2",
    managed_by      = "Terraform"
    terraform_module = "aks"
    terragrunt_dir = get_terragrunt_dir()
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/azure/aks/cluster/"
}

inputs = {
  cluster_name = "dev"
  location = "eastus2"
  dns_prefix = "dev"

  default_node_pool_instance_size = "Standard_B2s"

  api_server_authorized_ip_ranges = [    
    "38.30.0.0/24",
    "136.24.0.0/24",
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

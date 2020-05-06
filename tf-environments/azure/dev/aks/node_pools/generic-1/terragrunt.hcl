include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//tf-modules/azure/aks/node_pool/?ref=v0.1.23"
}

dependency "kubernetes_cluster" {
  config_path  = "../../cluster"
  mock_outputs = {
    cluster_id = "12345"
  }
}

dependencies {
  paths = [
    "../../cluster",
  ]
}

inputs = {
  kubernetes_cluster_id = dependency.kubernetes_cluster.outputs.cluster_id

  node_pool_name = "generic1"
  vm_size = "Standard_B2s"

  node_count = 1
  max_count  = 1
  min_count  = 1

  tags = {
    Environment     = "dev",
    Account         = "dev",
    Group           = "devops",
    Location        = "eastus2",
    managed_by      = "Terraform"
    terraform_module = "aks"
    node_pool       = "generic1"
    terragrunt_dir = get_terragrunt_dir()
  }
}

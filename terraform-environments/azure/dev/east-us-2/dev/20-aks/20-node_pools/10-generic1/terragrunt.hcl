# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//terraform-modules/azure/aks/node_pool/?ref=v2.0.51"
}

dependency "kubernetes_cluster" {
  config_path  = "../../10-cluster"
  mock_outputs = {
    cluster_id = "12345"
  }
}

dependency "vnet" {
  config_path  = "../../../10-network/10-vnet/"
  mock_outputs = {
    subnets = "12345"
  }
}

dependencies {
  paths = [
    "../../10-cluster",
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Load env-common variables shared across all accounts
  env_common_vars = read_terragrunt_config(find_in_parent_folders("env-common.hcl"))

  # Load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Load cluster-level variables
#   cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster.hcl"))

  tags = {
    ops_env              = local.env_common_vars.locals.environment_name
    ops_managed_by       = "terraform"
    ops_source_repo      = local.common_vars.locals.repository_name
    ops_source_repo_path = "${local.common_vars.locals.base_repository_path}/${path_relative_to_include()}"
    ops_owners           = "devops"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  kubernetes_cluster_id = dependency.kubernetes_cluster.outputs.cluster_id

  node_pool_name = "generic1"
  vm_size = "Standard_B2s"

  # This will select the subnet with the name "SNET-AKS-Private-1" in the output
  vnet_subnet_id = [for output in dependency.vnet.outputs.subnets : output.id if output.name == "SNET-AKS-Private-1"][0]

  node_count = 1
  max_count  = 1
  min_count  = 1

  tags = local.tags
}

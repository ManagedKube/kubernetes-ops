# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//terraform-modules/azure/aks/cluster2/?ref=v2.0.50"
}

dependency "vnet" {
  config_path  = "../../10-network/10-vnet/"
  mock_outputs = {
    subnets = "12345"
  }
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

  foo = toset(["a", "b", "c"])
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  resource_group_name = local.environment_vars.locals.azure_resource_group_name

  cluster_name = local.environment_vars.locals.aks_cluster_name
  location = "eastus2"
  dns_prefix = local.environment_vars.locals.aks_cluster_name

  # Specifies whether a Public FQDN for this Private Cluster should be added
  private_cluster_public_fqdn_enabled = true

  private_cluster_enabled = true

  # You will want this to be true for production
  # Setting it to false right now b/c Garland don't have permissions to see
  # the Azure user/roles to give us access to this if we use the Azure IAM for kubectl auth
  local_account_disabled = false
#   azure_active_directory_role_based_access_control_managed = false
#   azure_active_directory_role_based_access_control_azure_rbac_enabled = false
  role_based_access_control_enabled = false

  kubernetes_version = "1.24.3"

  # Setting to false
  # │ Resource Name: "dev01"): managedclusters.ManagedClustersClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="SubscriptionNotEnabledEncryptionAtHost" Message="Subscription does not enable EncryptionAtHost."
  default_node_pool_enable_host_encryption = false

  default_node_pool_instance_size = "Standard_B4ms"

  api_server_authorized_ip_ranges = []

  # This will select the subnet with the name "SNET-AKS-Private-1" in the output
  default_node_pool_vnet_subnet_id = [for output in dependency.vnet.outputs.subnets : output.id if output.name == "SNET-AKS-Private-1"][0]
  
  # Default pool autoscaling setting
  default_node_pool_min_count = 2
  default_node_pool_max_count = 10

  tags = local.tags
}

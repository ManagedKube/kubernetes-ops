# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//terraform-modules/azure/networking/vnet/?ref=v2.0.50"
}

# dependencies {
#   paths = ["../../5-vpc"]
# }

# dependency "vpc" {
#   config_path = "${get_terragrunt_dir()}/../../5-vpc"
#   # skip_outputs = true

#   mock_outputs = {
#     vpc_id         = "vpc-abcd1234"
#     vpc_cidr_block = "10.0.0.0/16"
#     public_subnets = ["subnet-abcd1234"]
#     k8s_subnets    = ["subnet-abcd1234"]
#   }
#   # mock_outputs_allowed_terraform_commands = ["validate", ]
# }

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

  resource_group_name = local.environment_vars.locals.azure_resource_group_name
  vnet_name = "VNET-DEV-EASTUS2-AKS-01"

  address_space = ["10.131.32.0/19"]

  subnets = [
    {
      name           = "SNET-AKS-Private-1"
      address_prefix = "10.131.32.0/21"
    },
    {
      name           = "SNET-AKS-Private-2"
      address_prefix = "10.131.40.0/21"
    },
    {
      name           = "SNET-AKS-Private-3"
      address_prefix = "10.131.48.0/21"
    },
    {
      name           = "SNET-AKS-Public-1"
      address_prefix = "10.131.56.0/23"
    },
    {
      name           = "SNET-AKS-Public-2"
      address_prefix = "10.131.58.0/23"
    },
    {
      name           = "SNET-AKS-Public-3"
      address_prefix = "10.131.60.0/23"
    },
  ]

  security_rules = [
    {
        name                       = "allow_all_inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow_all_outbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  ]

  # Null sets it to Azure provided DNS
  dns_servers = null

  tags = local.tags
}

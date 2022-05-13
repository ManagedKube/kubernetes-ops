# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.53"
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  tags = {
    ops_env              = local.common_vars.locals.environment_name
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
  aws_region = local.region_vars.locals.aws_region
  azs = ["${local.region_vars.locals.aws_region}${local.environment_vars.locals.vpc["availability_zones"][0]}",
    "${local.region_vars.locals.aws_region}${local.environment_vars.locals.vpc["availability_zones"][1]}",
    "${local.region_vars.locals.aws_region}${local.environment_vars.locals.vpc["availability_zones"][2]}",
  ]

  vpc_cidr        = local.environment_vars.locals.vpc["cidr"]
  private_subnets = local.environment_vars.locals.vpc["private_subnets"]
  public_subnets  = local.environment_vars.locals.vpc["public_subnets"]
  single_nat_gateway = true

  environment_name = local.environment_vars.locals.cluster_name
  cluster_name     = local.environment_vars.locals.cluster_name

  tags             = local.tags
}

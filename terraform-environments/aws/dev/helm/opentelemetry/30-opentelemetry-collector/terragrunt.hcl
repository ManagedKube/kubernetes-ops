terraform {
  source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kubernetes/manifest_set?ref=v2.0.12"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "${get_terragrunt_dir()}/../../../0200-eks"

  mock_outputs = {
    vpc_id            = "vpc-abcd1234"
    vpc_cidr_block    = "10.0.0.0/16"
    public_subnet_ids = ["subnet-abcd1234", "subnet-bcd1234a", ]
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
}

# Generate a Kubernetes provider configuration for authenticating against the EKS cluster.
generate "k8s_helm" {
  path      = "k8s_helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile(
    find_in_parent_folders("provider_k8s_helm_for_eks.template.hcl"),
    {
      eks_cluster_name = dependency.eks.outputs.cluster_id,
      kubergrunt_exec = get_env("KUBERGRUNT_EXEC", "kubergrunt")
    },
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Extract the name prefix for easy access
  name_prefix = local.common_vars.locals.name_prefix

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract the account_name for easy access
  account_name = local.account_vars.locals.account_name

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the region for easy access
  aws_region = local.region_vars.locals.aws_region

}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  upload_source_path = "${get_terragrunt_dir()}"
  upload_directory   = "yaml"
  fileset_pattern    = "**/*.yaml"
  template_vars      = {}
}

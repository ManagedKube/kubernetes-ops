# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  // This is an example on how to structure your testkube so that you can use the kubernetes-ops `base-tests`
  // and have your own `local` tests (this directory).  While this `local` directory resides in this kubernetes-ops
  // repo, it is really meant to go into your own repo and you can reference the source from there.  The reason
  // is that the set of tests here in this module is specific to you and really to no one else.
  source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/testkube/local?ref=testkube-testing"
}

dependency "eks" {
  config_path = "${get_terragrunt_dir()}/../../../200-eks"

  mock_outputs = {
    zone_id = "zzzz"
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
  app_namespace = "my-app"
}

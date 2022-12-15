# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/istio?ref=v2.0.44"
}

dependency "aks" {
  config_path = "${get_terragrunt_dir()}/../../../20-aks/10-cluster"

  mock_outputs = {
    kube_config = "zzzz"
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
}

dependency "vault" {
  config_path = "${get_terragrunt_dir()}/../../../30-vault"

  mock_outputs = {
    kube_config = "zzzz"
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
}

# Generate a Kubernetes provider configuration for authenticating against the EKS cluster.
generate "k8s_helm" {
  path      = "k8s_helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile(
    find_in_parent_folders("provider_k8s_helm.template.hcl"),
    {
        cluster_name = local.environment_vars.locals.aks_cluster_name
        cluster_resource_group = local.environment_vars.locals.azure_resource_group_name
    },
  )
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
  helm_values_istio_base    = file("istio_base_values.yaml")
  helm_values_istiod        = file("istiod_values.yaml")
  helm_values_istio_ingress = templatefile(
    "istio_ingress_values.tpl.yaml",
    {
      # domain_name            = local.environment_vars.locals.domain_name
    }
  )
}

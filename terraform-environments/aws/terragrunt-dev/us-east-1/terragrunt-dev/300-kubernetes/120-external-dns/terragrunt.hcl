# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/external-dns?ref=external-dns-update"
}

dependency "eks" {
  config_path = "${get_terragrunt_dir()}/../../200-eks"

  mock_outputs = {
    zone_id = "zzzz"
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
}

dependency "route53_hosted_zone" {
  config_path = "${get_terragrunt_dir()}/../../100-route53-hostedzone"

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
  aws_region                  = local.region_vars.locals.aws_region
  cluster_name                = local.common_vars.locals.environment_name
  eks_cluster_id              = dependency.eks.outputs.cluster_id
  eks_cluster_oidc_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url
  route53_hosted_zones        = dependency.route53_hosted_zone.outputs.zone_id
  helm_values_2               = file("values.yaml")
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/eks?ref=v2.0.29"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../150-vpc"

  mock_outputs = {
    vpc_id            = "vpc-abcd1234"
    vpc_cidr_block    = "10.0.0.0/16"
    public_subnet_ids = ["subnet-abcd1234", "subnet-bcd1234a", ]
  }
  mock_outputs_allowed_terraform_commands = ["validate", ]
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

  eks_cluster_version = "1.22"

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
  aws_region       = local.region_vars.locals.aws_region
  environment_name = local.common_vars.locals.environment_name
  tags             = local.tags

  cluster_name     = local.common_vars.locals.environment_name

  vpc_id           = dependency.vpc.outputs.vpc_id
  k8s_subnets      = dependency.vpc.outputs.k8s_subnets
  public_subnets   = dependency.vpc.outputs.public_subnets

  cluster_version                      = local.eks_cluster_version
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  kubectl_binary = "/github/workspace/kubectl"
  
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${get_aws_account_id()}:role/github_oidc_${local.common_vars.locals.environment_name}"
      username = "github-actions-pipeline-access"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${get_aws_account_id()}:role/AWSReservedSSO_AdministratorAccess_1f8d5e80fd7b3359"
      username = "sso-admin-users"
      groups   = ["system:masters"]
    },
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${get_aws_account_id()}:user/gkan-temp"
      username = "gkan-temp"
      groups   = ["system:masters"]
    },
  ]

  eks_managed_node_groups = {
    ng1 = {
      create_launch_template = false
      launch_template_name   = ""

      # Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
      # (Optional) Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
      force_update_version = true

      # doc: https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
      # doc: https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami-bottlerocket.html
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"
      version  = local.eks_cluster_version

      disk_size      = 20
      desired_size   = 2
      max_size       = 3
      min_size       = 0
      instance_types = ["t3.medium"]
      additional_tags  = local.tags
      k8s_labels       = {}
    }
  }
}


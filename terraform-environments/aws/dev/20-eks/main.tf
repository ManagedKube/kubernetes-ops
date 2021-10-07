locals {
  aws_region       = "us-east-1"
  environment_name = "dev"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/20-eks",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-dev-20-eks"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "managedkube"
    workspaces = {
      name = "kubernetes-ops-${local.environment_name}-10-vpc"
    }
  }
}

#
# EKS
#
module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=main"

  aws_region = local.aws_region
  tags       = local.tags

  cluster_name = local.environment_name

  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  k8s_subnets    = data.terraform_remote_state.vpc.outputs.k8s_subnets
  public_subnets = data.terraform_remote_state.vpc.outputs.public_subnets

  cluster_version = "1.20"

  # public cluster - kubernetes API is publicly accessible
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0",
    "1.1.1.1/32",
  ]

  # private cluster - kubernetes API is internal the the VPC
  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
    "100.64.0.0./16",
  ]

  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::725654443526:user/username"
      username = "username"
      groups   = ["system:masters"]
    },
  ]

  node_groups = {
    ng1 = {
      disk_size        = 20
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1
      instance_types   = ["t3.small"]
      additional_tags  = local.tags
      k8s_labels       = {}
    }
  }

  # depends_on = [
  #   module.vpc
  # ]
}

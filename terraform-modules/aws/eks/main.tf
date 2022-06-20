terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.1.0"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
  enable_key_rotation = var.cluster_kms_enable_rotation
  tags        = var.tags
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "18.23.0"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  enable_irsa      = var.enable_irsa
  tags             = var.tags

  # vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_id = var.vpc_id

  # Using a conditional for backwards compatibility for those who started out only
  # using the private_subnets for the input variable.  The new k8s_subnets is new
  # and makes the subnet id input var name more generic to where the k8s worker nodes goes
  subnet_ids = length(var.private_subnets) > 0 ? var.private_subnets : var.k8s_subnets

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  
  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cluster_enabled_log_types     = var.cluster_enabled_log_types

  eks_managed_node_groups = var.eks_managed_node_groups

  node_security_group_additional_rules = var.node_security_group_additional_rules

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = var.aws_auth_roles

  aws_auth_users = var.aws_auth_users

  aws_auth_accounts = var.aws_auth_accounts
}

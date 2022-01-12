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
  tags        = var.tags
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "v18.0.6"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  enable_irsa      = var.enable_irsa
  write_kubeconfig = false
  tags             = var.tags

  # vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_id = var.vpc_id

  # Using a conditional for backwards compatibility for those who started out only
  # using the private_subnets for the input variable.  The new k8s_subnets is new
  # and makes the subnet id input var name more generic to where the k8s worker nodes goes
  subnets = length(var.private_subnets) > 0 ? var.private_subnets : var.k8s_subnets

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_endpoint_private_access                = var.cluster_endpoint_private_access
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cluster_log_retention_in_days = var.cluster_log_retention_in_days
  cluster_enabled_log_types     = var.cluster_enabled_log_types

  map_roles = var.map_roles
  map_users = var.map_users

  node_groups = var.node_groups

}

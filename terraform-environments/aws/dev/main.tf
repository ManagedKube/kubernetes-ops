terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "managedkube"

    # The workspace must be unique to this terraform
    workspaces {
      name = "terraform-environments_aws_dev_vpc"
    }
  }
}

provider "aws" {
  version = "~> 3.37.0"
  region  = var.aws_region
}

#
# EKS authentication
#
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.environment_name]
      command     = "aws"
    }
  }
}
# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_id
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     token                  = data.aws_eks_cluster_auth.eks.token
#     cluster_ca_certificate = base64decode(module.eks.certificate_authority.0.data)
#   }
# }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority.0.data)
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.cluster_id
# }

# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_id
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     token                  = data.aws_eks_cluster_auth.eks.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
#   }
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   token                  = data.aws_eks_cluster_auth.eks.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
# }

#
# VPC
#
module "vpc" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.1"

  aws_region       = var.aws_region
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = var.environment_name
  tags             = var.tags
}

#
# EKS
#
module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=tf-argo-module"

  aws_region = var.aws_region
  tags       = var.tags

  cluster_name = var.environment_name

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  cluster_version                = "1.18"
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
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
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  node_groups = {
    ng1 = {
      disk_size        = 20
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1
      instance_type    = "t2.small"
      additional_tags  = var.tags
      k8s_labels       = {}
    }
  }



  # depends_on = [
  #   module.vpc
  # ]
}

#
# Helm - ArgoCD
#
module "argocd" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/argocd?ref=tf-argo-module"

  depends_on = [
    module.eks
  ]
}

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
      name = "kubernetes-ops-staging-25-eks-cluster-autoscaler"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "managedkube"
    workspaces = {
      name = "kubernetes-ops-staging-20-eks"
    }
  }
}

#
# EKS authentication
# # https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.environment_name]
      command     = "aws"
    }
  }
}

#
# Helm - cluster-autoscaler
#
module "cluster-autoscaler" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/cluster-autoscaler?ref=v1.0.12"

  aws_region                  = var.aws_region
  cluster_name                = var.environment_name
  eks_cluster_id              = data.terraform_remote_state.eks.outputs.cluster_id
  eks_cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url

  depends_on = [
    data.terraform_remote_state.eks
  ]
}

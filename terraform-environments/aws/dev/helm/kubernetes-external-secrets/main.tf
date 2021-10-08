locals {
  aws_region       = "us-east-1"
  environment_name = "dev"
  secrets_prefix   = "managedkube/"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/helm/kubernetes-external-secrets",
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
      name = "kubernetes-ops-dev-helm-kubernetes-external-secrets"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = "managedkube"
    workspaces = {
      name = "kubernetes-ops-${local.environment_name}-20-eks"
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
      args        = ["eks", "get-token", "--cluster-name", local.environment_name]
      command     = "aws"
    }
  }
}

#
# Helm - kube-prometheus-stack
#
module "kubernetes-external-secrets" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/kubernetes-external-secrets?ref=v1.0.20"

  eks_cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url
  helm_values                 = file("${path.module}/values.yaml")
  environment_name            = local.environment_name
  secrets_prefix              = local.secrets_prefix

  depends_on = [
    data.terraform_remote_state.eks
  ]
}

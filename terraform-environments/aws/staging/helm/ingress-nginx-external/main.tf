locals {
  aws_region       = "us-east-1"
  environment_name = "staging"
  namespace        = "ingress-nginx"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/helm/ingress-nginx-external",
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
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-staging-helm-ingress-nginx"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    # Update to your Terraform Cloud organization
    organization = "managedkube"
    workspaces = {
      name = "kubernetes-ops-staging-20-eks"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", "${local.environment_name}"]
      command     = "aws"
    }
  }
}

data "aws_eks_cluster_auth" "main" {
  name = local.environment_name
}

# Helm values file templating
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")

  # Parameters you want to pass into the helm_values.yaml.tpl file to be templated
  vars = {}
}

module "ingress-nginx-external" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.15"

  # this is the helm repo add URL
  repository = "https://kubernetes.github.io/ingress-nginx"
  # This is the helm repo add name
  official_chart_name = "ingress-nginx"
  # This is what you want to name the chart when deploying
  user_chart_name = "ingress-nginx"
  # The helm chart version you want to use
  helm_version = "3.30.0"
  # The namespace you want to install the chart into - it will create the namespace if it doesnt exist
  namespace = local.namespace
  # The helm chart values file
  helm_values = data.template_file.helm_values.rendered

  depends_on = [
    data.terraform_remote_state.eks
  ]
}


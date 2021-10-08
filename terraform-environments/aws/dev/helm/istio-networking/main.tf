locals {
  aws_region       = "us-east-1"
  environment_name = "dev"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/helm/kube-prometheus-stack",
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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "remote" {
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-dev-helm-istio-networking"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "terraform-states-016733450475"
    key    = "terraform-environments/aws/dev/20-eks"
    region = "us-east-1"
  }
}

data "aws_eks_cluster_auth" "main" {
  name = data.terraform_remote_state.eks.outputs.environment_name
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

# file templating
data "template_file" "gateway_yaml" {
  template = file("${path.module}/gateway.tpl.yaml")

  # vars = {
  #   fullnameOverride  = local.fullnameOverride
  # }
}

resource "kubectl_manifest" "gateway" {
  yaml_body = data.template_file.gateway_yaml.rendered
}

# file templating
data "template_file" "virtualservice_yaml" {
  template = file("${path.module}/virtualservice.tpl.yaml")

  # vars = {
  #   fullnameOverride  = local.fullnameOverride
  # }
}

resource "kubectl_manifest" "virtualservice" {
  yaml_body = data.template_file.virtualservice_yaml.rendered
}

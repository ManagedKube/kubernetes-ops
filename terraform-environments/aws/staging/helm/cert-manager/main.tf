locals {
  aws_region         = "us-east-1"
  environment_name   = "staging"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/helm/cert-manager",
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
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-staging-helm-cert-manager"
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

data "terraform_remote_state" "route53_hosted_zone" {
  backend = "remote"
  config = {
    # Update to your Terraform Cloud organization
    organization = "managedkube"
    workspaces = {
      name = "kubernetes-ops-staging-5-route53-hostedzone"
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
      args        = ["eks", "get-token", "--cluster-name", "${local.environment_name}"]
      command     = "aws"
    }
  }
}

data "aws_eks_cluster_auth" "main" {
  name = local.environment_name
}

provider "kubectl" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

# Helm values file templating
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.yaml")

  # Parameters you want to pass into the helm_values.yaml.tpl file to be templated
  vars = {}
}

resource "kubectl_manifest" "ClusterIssuer" {
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
  namespace: cert-manager
spec:
  acme:
    email: admin@managedkube.com
    privateKeySecretRef:
      name: letsencrypt
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
  depends_on = [module.cert-manager]
}


#
# Helm - cert-manager
#
module "cert-manager" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.9"

  # this is the helm repo add URL
  repository = "https://charts.jetstack.io"
  # This is the helm repo add name
  official_chart_name = "cert-manager"
  # This is what you want to name the chart when deploying
  user_chart_name = "cert-manager"
  # The helm chart version you want to use
  helm_version = "v1.3.1"
  # The namespace you want to install the chart into - it will create the namespace if it doesnt exist
  namespace = "cert-manager"
  # The helm chart values file
  helm_values = data.template_file.helm_values.rendered

  depends_on = [
    data.terraform_remote_state.eks
  ]
}

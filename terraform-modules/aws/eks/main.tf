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

locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.cluster.token
      }
    }]
  })

  current_auth_configmap = yamldecode(module.eks.aws_auth_configmap_yaml)

  updated_auth_configmap_data = {
    data = {
      mapRoles = yamlencode(
        distinct(concat(
        yamldecode(local.current_auth_configmap.data.mapRoles), var.map_roles, )
      ))
      mapUsers = yamlencode(var.map_users)
    }
  }

}

# resource "null_resource" "patch_aws_auth_configmap" {
#   triggers = {
#     cmd_patch = "kubectl patch configmap/aws-auth -n kube-system --type merge -p '${chomp(jsonencode(local.updated_auth_configmap_data))}' --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
#   }

#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = self.triggers.cmd_patch

#     environment = {
#       KUBECONFIG = base64encode(local.kubeconfig)
#     }
#   }
# }

output "tmp" {
  value = local.kubeconfig
}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
  tags        = var.tags
}

module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "18.2.6"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  enable_irsa      = var.enable_irsa
  # write_kubeconfig = false
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
  cluster_security_group_additional_rules        = var.cluster_security_group_additional_rules

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cluster_enabled_log_types     = var.cluster_enabled_log_types

  # map_roles = var.map_roles
  # map_users = var.map_users

  eks_managed_node_groups = var.eks_managed_node_groups

}


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
  version          = "18.2.6"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  enable_irsa      = var.enable_irsa
  tags             = var.tags

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

  eks_managed_node_groups = var.eks_managed_node_groups

}

################################################################################
# aws-auth configmap
# Only EKS managed node groups automatically add roles to aws-auth configmap
# so we need to ensure fargate profiles and self-managed node roles are added
################################################################################

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

  configmap_roles = [
    for item in module.eks.eks_managed_node_groups:
    {
      # Work around https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/153
      # Strip the leading slash off so that Terraform doesn't think it's a regex
      rolearn  = item.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = tolist(concat(
        [
          "system:bootstrappers",
          "system:nodes",
        ],
      ))
    }
  ]

  full_aws_auth_configmap = yamlencode({
    apiVersion = "v1"
    kind = "ConfigMap"
    metadata = {
      name = "aws-auth"
      namespace = "kube-system"
    }
    data = {
      mapRoles = yamlencode(
        distinct(concat(
          local.configmap_roles,
          var.map_roles,
        ))
      )
      mapUsers    = yamlencode(var.map_users)
      mapAccounts = yamlencode(var.map_accounts)
    }
  })
  
}

resource "null_resource" "patch" {
  triggers = {
    kubeconfig = base64encode(local.kubeconfig)    
    cmd_patch  = "echo $KUBECONFIG | base64 -d > ./kubeconfig; echo \"${local.full_aws_auth_configmap}\" | /github/workspace/kubectl apply -n kube-system --kubeconfig ./kubeconfig -f -"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = self.triggers.cmd_patch
  }
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

resource "aws_ec2_tag" "vpc_tag" {
  resource_id = data.terraform_remote_state.vpc.outputs.vpc_id
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_tag" {
  count = length(var.private_subnets)
  resource_id = [data.terraform_remote_state.vpc.outputs.private_subnets[count.index].id]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  count =       length(var.private_subnets)
  resource_id = [data.terraform_remote_state.vpc.outputs.private_subnets[count.index].id]
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_tag" {
  
  count = length(var.public_subnets)
  resource_id = [data.terraform_remote_state.vpc.outputs.public_subnets[count.index].id]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  count = length(var.public_subnets)
  resource_id = [data.terraform_remote_state.vpc.outputs.public_subnets[count.index].id]
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}


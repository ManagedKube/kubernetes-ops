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

locals {
  cluster_addons_iam = { 
    for k, v in var.cluster_addons : k => {
      name                          = v.name
      addon_version                 = v.addon_version
      resolve_conflicts_on_create   = v.resolve_conflicts_on_create
      resolve_conflicts_on_update   = v.resolve_conflicts_on_update
      preserve                      = v.preserve
      configuration_values          = v.configuration_values
      timeouts                      = v.timeouts
      service_account_role_arn      = (k == "aws-ebs-csi-driver" ? data.aws_iam_role.eks_csi_driver.arn : k == "vpc-cni" ? data.aws_iam_role.eks_cni_driver.arn : null)
    }
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_iam_role" "eks_csi_driver" {
  name = aws_iam_role.eks_ebs_csi_driver.name
}

data "aws_iam_role" "eks_cni_driver" {
  name = aws_iam_role.eks_cni_driver.name
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

module "kms_cloudwatch_log_group" {
  source                  = "github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/kms/cloudwatch_log_group?ref=v2.0.37"
  log_group_name          = "/aws/eks/${var.cluster_name}/cluster"
  tags                    = var.tags
}

//EKS 1.23
/* It needs Amazon EBS CSI driver in order to mount volume. 
https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
ebs csi driver is available since 1.14 so it shouldn't impact in previous versions
that it's using this module.
https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
*/

# IAM CSI Role
data "aws_iam_policy_document" "csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.csi.json
  name               = "eks-ebs-csi-driver"
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# IAM CNI
data "aws_iam_policy_document" "cni" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_cni_driver" {
  assume_role_policy = data.aws_iam_policy_document.cni.json
  name               = "eks-cni-driver"
}

resource "aws_iam_role_policy_attachment" "amazon_cni_driver" {
  role       = aws_iam_role.eks_cni_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEKS_CNI_Policy"
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

  cloudwatch_log_group_kms_key_id = module.kms_cloudwatch_log_group.kms_arn
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cluster_enabled_log_types     = var.cluster_enabled_log_types

  eks_managed_node_groups = var.eks_managed_node_groups

  node_security_group_additional_rules = var.node_security_group_additional_rules

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = var.aws_auth_roles

  aws_auth_users = var.aws_auth_users

  aws_auth_accounts = var.aws_auth_accounts

  cluster_addons = local.cluster_addons_iam 
}

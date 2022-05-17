module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = var.environment_name
  cidr = var.vpc_cidr

  secondary_cidr_blocks = var.secondary_cidrs

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # We want to use the 100.64.0.0/16 address space for the EKS nodes and since
  # this module doesnt have an EKS subnet, we will use the elasticache instead.
  elasticache_subnets = var.k8s_worker_subnets

  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  reuse_nat_ips       = var.reuse_nat_ips
  external_nat_ip_ids = var.external_nat_ip_ids
  enable_vpn_gateway  = var.enable_vpn_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # Removed k8s tagging of public subnets as this makes LB to route to public subnets too - Sridhar
  # public_subnet_tags = merge(local.eks_tags, { "kubernetes.io/role/elb" = "1" })

  private_subnet_tags = merge(local.eks_tags, { "kubernetes.io/role/intenal-elb" = "1" })

  
  # dynamic "private_subnet_tags" {
  #   for_each = var.cluster_name
  #   content {
  #     "kubernetes.io/cluster/${private_subnet_tags.value}" = "shared"
  #   }
  # }

  # elasticache_subnet_tags = {
  #   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"           = "1"
  #   "ops_purpose"                               = "Overloaded for k8s worker usage"
  # }

  tags = var.tags
}

locals {
  eks_tags = {}
  # eks_tags = {
  #   "kubernetes.io/cluster/${var.cluster_name[0]}" = "shared"
  #   "kubernetes.io/cluster/${var.cluster_name[0]}" = "shared"
  #   "kubernetes.io/cluster/${var.cluster_name[1]}" = "shared"
  #   "kubernetes.io/cluster/${var.cluster_name[2]}" = "shared"
  #   "kubernetes.io/cluster/${var.cluster_name[3]}" = "shared"
  # }
}
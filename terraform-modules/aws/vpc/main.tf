module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = var.environment_name
  cidr = var.vpc_cidr

  secondary_cidr_blocks    = var.secondary_cidrs

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # We want to use the 100.64.0.0/16 address space for the EKS nodes and since
  # this module doesnt have an EKS subnet, we will use the elasticache instead.
  elasticache_subnets   = var.k8s_worker_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  elasticache_subnet_tags  = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = var.tags
}

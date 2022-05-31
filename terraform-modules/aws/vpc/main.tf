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
  reuse_nat_ips       = var.reuse_nat_ips
  external_nat_ip_ids = var.external_nat_ip_ids
  enable_vpn_gateway  = var.enable_vpn_gateway

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

  elasticache_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    "ops_purpose"                               = "Overloaded for k8s worker usage"
  }
  
  tags = var.tags

  #Default Security Group Management (Default: secure)
  manage_default_security_group   = var.manage_default_security_group
  default_security_group_name     = var.default_security_group_name
  default_security_group_egress   = var.default_security_group_egress
  default_security_group_ingress  = var.default_security_group_ingress
  default_security_group_tags     = var.default_security_group_tags
  
}

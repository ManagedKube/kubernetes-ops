terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "managedkube"

    # The workspace must be unique to this terraform
    workspaces {
      name = "terraform-environments_aws_dev_vpc"
    }
  }
}

provider "aws" {
    version = "~> 3.37.0"
    region = var.aws_region
}

module "vpc" {
  # source = "./vpc"
  # source = "git@github.com:ManagedKube/kubernetes-ops.git//terraform-modules/aws/vpc?ref=eks-v2"
  # source = "https://github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/vpc?ref=eks-v2"
  # source = "git::ssh://git@github.com/ManagedKube/kubernetes-ops.git//terraform-modules/aws/vpc?ref=eks-v2"
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=eks-v2"

  aws_region = var.aws_region
  vpc_cidr   = var.vpc_cidr
  environment_name = var.environment_name
  tags = var.tags
}

module "eks" {
  source = "./eks"
  
  aws_region = var.aws_region
  environment_name = var.environment_name
  tags = var.tags

  cluster_name = var.environment_name

  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets

  # depends_on = [
  #   module.vpc
  # ]
}

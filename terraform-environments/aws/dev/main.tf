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
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=eks-v2"

  aws_region = var.aws_region
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr   = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = var.environment_name
  tags = var.tags
}

module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=eks-v2"
  
  aws_region = var.aws_region
  tags = var.tags

  cluster_name = var.environment_name

  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets

  # depends_on = [
  #   module.vpc
  # ]
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    # random = {
    #   source = "hashicorp/random"
    # }
  }

  backend "remote" {
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-staging-10-vpc"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#
# VPC
#
module "vpc" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.18"

  aws_region       = var.aws_region
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = var.environment_name
  cluster_name     = var.environment_name
  tags             = var.tags
}

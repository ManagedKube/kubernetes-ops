locals {
  aws_region       = "us-east-1"
  environment_name = "dev"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/20-eks",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    organization = "managedkube"

    workspaces {
      name = "kubernetes-ops-dev-ssm-ec2-role"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#
# SSM Role
#
module "ssm_role" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/ssm/ec2-role?ref=v1.0.22"

  region           = local.aws_region
  name             = local.environment_name
  s3_bucket_name   = "foo"
  s3_bucket_prefix = "bar"
  tags             = local.tags

}

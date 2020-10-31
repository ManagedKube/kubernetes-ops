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
      name = "terraform-environments_aws_dev_eks"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "managedkube"
    workspaces = {
      name = "terraform-environments_aws_dev_vpc"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.17"
  subnets = [
    data.terraform_remote_state.vpc.outputs.private_subnets[0],
    data.terraform_remote_state.vpc.outputs.private_subnets[1],
    data.terraform_remote_state.vpc.outputs.private_subnets[2]
  ]
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
  ]
}

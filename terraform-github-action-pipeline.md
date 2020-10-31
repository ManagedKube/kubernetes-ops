Terraform Github Actions Pipeline
================================

Based on this tutorial: https://learn.hashicorp.com/tutorials/terraform/github-actions


```
 terraform {
  backend "remote" {
    organization = "managedkube"

    # The workspace name is the path to the Terraform file with an underscore as the directory delimitor because a / is not allowed in 
    # the workspace's name.
    workspaces {
      name = "path-to-terraform-file"
    }
  }
}
```

## Github Actions workflow syntax

https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions

## Usage

Will have to create a pipeline for each Terraform you want to "sync" up.  Not so GitOps-ey...i kinda want to get away from creating distinct pipelines.


## Getting remote state
At times you will have to get information that was created by another Terraform.  For example, you might create a generic VPC that holds all of your resources then you might create an EKS cluster and an RDS in that VPC.  Instead of combining those Terraforms into one big Terraform, you can separate it out.  However, to create your EKS cluster or RDS, you will need to know certain information like the VPC ID and the subnets you want to put them into.  With this, you can get that data and use it in the EKS or RDS Terraform.

https://www.terraform.io/docs/cloud/workspaces/state.html

```
data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "example_corp"
    workspaces = {
      name = "vpc-prod"
    }
  }
}

resource "aws_instance" "redis_server" {
  # Terraform 0.12 syntax: use the "outputs.<OUTPUT NAME>" attribute
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id

  # Terraform 0.11 syntax: use the "<OUTPUT NAME>" attribute
  subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
}
```

## Delete workflow.
The delete workflow is not so great.  I would ideally like to be able to delete the item from Git and have a plan and apply on merge to destroy the resources.

You have to go into the Terraform's Cloud UI and into your workspace to delete the resources:
https://learn.hashicorp.com/tutorials/terraform/cloud-destroy?in=terraform/cloud-get-started#delete-the-terraform-cloud-workspace

## Order of commiting
There is an order you have to commit the files.  You will have to commit the VPC Terraform and let it create before commiting and merging the EKS cluster Terraform because the EKS Terraform depends on information from the VPC Terraform.  If that information is not there, the EKS cluster Terraform will fail.

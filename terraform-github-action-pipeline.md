Terraform Github Actions Pipeline
================================

Based on this tutorial: https://learn.hashicorp.com/tutorials/terraform/github-actions

## Setting up Github access to Terraform Cloud
Our Github Actions will run the Terraform we have locally but it will execute in Terraform Cloud.  We will have to give Github Actions permission to Terraform Cloud so it can perform this action.

## Get Terraform Cloud token
This will be an access token used in Github to acces Terraform Cloud

* Go to: https://app.terraform.io/app/settings/tokens
* Click on `Create an API Token`
* Name it after the environment name
* Save the token for later use

## Setup the Github repository
* Either use an exiting repository or create a new repository
* In your Github repository go to: `Settings->Secrets`
* Click on `New repository secret`

If you only have one environment, then create a secret named: `TF_API_TOKEN`
If you have multiple environments, create a secret named `TF_API_TOKEN_<ENV>` where `<ENV>` is the environment name.  This is the Terraform Cloud token and we will use a different token for each environment.

## Terraform Cloud Setup
We will need to create a few workspaces:
1. kubernetes-ops-staging-10-vpc
1. kubernetes-ops-staging-20-eks
1. kubernetes-ops-staging-25-eks-cluster-autoscaler
1. kubernetes-ops-staging-30-helm-kube-prometheus-stack

### Creatinging a new workspace
* Create a new workspace (API-Driven Workflow)
* Name it after your environment
* Docs: https://learn.hashicorp.com/tutorials/terraform/github-actions#set-up-terraform-cloud

You will then get back a config block like this:
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
Save this somewhere.

## Adding AWS permissions
* Cick on the `Variables` tab
* In the `Environment Variable` section add:

```
AWS_ACCESS_KEY_ID=<your key>
AWS_SECRET_ACCESS_KEY=<your key>
```

### Copy Github Actions workflow file over to your repository

Copy the file in this repo: `./.github/workflows/terraform-pipeline-<environment name>.yaml` file to your repo to the same location.

If you changed the `TF_API_TOKEN` variable name, you will have to change it in this file.  Update to what you changed it to.

You might have to change the path for where the pipeline will look for changes in this file as well to reflect your path:
```
terraform-environments/aws/dev
```

## Instantiating our cloud on AWS
The next set of steps will outline how we are going to build our Kubernetes cloud.  We will build our cloud through the following high level steps:

1. Create a VPC to hold our cloud
1. Create an EKS cluster
1. Setup Kubernetes Cluster Autoscaler
1. Install kube-prometheus-stack

### Adding Terraform files
You only need the `./terraform-environments` items.  These items uses the modules in this repository to instantiate everything in AWS.  You can copy the `./terraform-modules` into your repository and point your usage to that if you want but you won't get the automatic updates when this repository updates these modules.  You will have to copy over the changes.

Copy the `./terraform-environments` folder over to your repository.

You can rename the environment name to reflect what you want to name your environment to be.

### Update your Terraform Dloud backend information
For each environment we have a Terraform Cloud workspace.  This will help us to keep everything organized so that all of the Terraform state stores for each environment is in it's own segmented area.

In the original step above when we created the Terraform Cloud workspace, it gave you a config block.  We will now use that information and replace it in our Terraform file.

In the file `./terraform-environments/aws/dev/main.tf`, we will replace this section:
```
  backend "remote" {
    organization = "managedkube"

    # The workspace must be unique to this terraform
    workspaces {
      name = "terraform-environments_aws_dev_vpc"
    }
  }
```
With what your Terraform Cloud Workspace gave you.  If you are copying the items over from this repo, you will just have to change the `organization` name.

## Creating the VPC











## Github Actions workflow syntax

https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions

## Terraform Cloud

### Workspaces
In Terraform cloud, a workspace is like the directory where your Terraform files are located in and where you execute Terraform from and where Terraform puts the state file locally.  This means that every single new Terraform needs a new workspace.

https://www.terraform.io/docs/cloud/workspaces/index.html#workspaces-are-collections-of-infrastructure

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

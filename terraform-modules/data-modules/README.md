# Data Modules

Data modules are used to fetch Terraform state data from a state store.

Use case:
* If you have an infra repo containing your EKS cluster and an application repo that contains your Terraform for deployment.  You will need the EKS cluste info to be able to deploy into that cluster.  If you are using Terragrunt, you wont directly be able to use the "terraform_remote_state" Terraform resource.  The way that Terragrunt wants you to do things is to call a module.  This would be the module you would call to get the EKS output data so you can use it in other places if it is not in the same source Terragrunt repo that launched the EKS cluster.
* Problem described here: https://github.com/gruntwork-io/terragrunt/issues/759

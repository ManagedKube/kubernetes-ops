# terragrunt-dev

This is a version of kubernetes-ops where it uses the same Terraform modules but uses terragrunt
to wrap around Terraform for instantiation.  Terragrunt helps us out with DRYing the configurations.
For example, we don't have to repeat the backend state store information in every usage like we
would if we were just using pure Terraform.

## Folder names

The folder named `/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev`, might
seem redundant with two `terragrunt-dev` in the path.  The first `terragrunt-dev` is denoting
an environment level.  The second `terragrunt-dev` is denoting the environment name.

We could have named the second `terragrunt-dev` just `dev` or if we needed another dev type
environment we would create another one here: `/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev2`.  This gives us flexibility on how many "dev" type environment we want to create.

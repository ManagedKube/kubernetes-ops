# 050-github-aws-permissions

This is the Terraform that will create the IAM role that our Github Actions pipeline will assume
to gain access to our AWS account.

Since there is a chicken and egg problem here with how will our pipeline run with access to AWS
without something first giving it access, we will have to run this manually.

## Running
Change directory to the directory where this README.md file resides.

Execute:
```
terragrunt init
```

You will receive an output similar to the following:
```
WARN[0001] No double-slash (//) found in source URL /ManagedKube/terraform-aws-github-oidc-provider.git. Relative paths in downloaded Terraform code may not work. 
Remote state S3 bucket terraform-state-xxxxxxxxxx-us-east-1-terraform-dev does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/iam/aws 3.6.0 for iam_assumable_role_admin...
- iam_assumable_role_admin in .terraform/modules/iam_assumable_role_admin/modules/iam-assumable-role-with-oidc

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 2.23.0"...
- Installing hashicorp/aws v4.13.0...
- Installed hashicorp/aws v4.13.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

It will ask you to confirm creating the S3 bucket or not.  This S3 bucket is used to store the
Terraform state file.

Apply:
```
terragrunt apply
```

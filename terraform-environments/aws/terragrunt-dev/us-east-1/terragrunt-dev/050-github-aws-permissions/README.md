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

The output:
```
Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_openid_connect_provider.this[0] will be created
  + resource "aws_iam_openid_connect_provider" "this" {
      + arn             = (known after apply)
      + client_id_list  = [
          + "sts.amazonaws.com",
        ]
      + id              = (known after apply)
      + tags            = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
      + tags_all        = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
      + thumbprint_list = [
          + "6938fd4d98bab03faadb97b34396831e3780aea1",
        ]
      + url             = "https://token.actions.githubusercontent.com"
    }

  # aws_iam_policy.iam_policy will be created
  + resource "aws_iam_policy" "iam_policy" {
      + arn         = (known after apply)
      + description = "IAM Policy for the Github OIDC Federation permissions"
      + id          = (known after apply)
      + name        = (known after apply)
      + name_prefix = "github_oidc_terraform-dev"
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "*"
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags        = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
      + tags_all    = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
    }

  # module.iam_assumable_role_admin.aws_iam_role.this[0] will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRoleWithWebIdentity"
                      + Condition = {
                          + StringEquals = {
                              + "token.actions.githubusercontent.com:sub" = [
                                  + "repo:managedkube/kubernetes-ops:pull_request",
                                  + "repo:managedkube/kubernetes-ops:ref:refs/heads/main",
                                  + "repo:managedkube/kubernetes-ops:workflow_dispatch",
                                ]
                            }
                          + StringLike   = {
                              + "token.actions.githubusercontent.com:sub" = "repo:octo-org/octo-repo:ref:refs/heads/feature/*"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + Federated = "arn:aws:iam::xxxxxxxxxxxxxx:oidc-provider/token.actions.githubusercontent.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "github_oidc_terraform-dev"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
      + tags_all              = {
          + "ops_env"              = "terraform-dev"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "managedkube/kubernetes-ops"
          + "ops_source_repo_path" = "terraform-environments/aws/terraform-dev/us-east-1/terragrunt-dev/050-github-aws-permissions"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.iam_assumable_role_admin.aws_iam_role_policy_attachment.custom[0] will be created
  + resource "aws_iam_role_policy_attachment" "custom" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "github_oidc_terraform-dev"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + arn = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_iam_openid_connect_provider.this[0]: Creating...
aws_iam_policy.iam_policy: Creating...
module.iam_assumable_role_admin.aws_iam_role.this[0]: Creating...
aws_iam_openid_connect_provider.this[0]: Creation complete after 0s [id=arn:aws:iam::xxxxxxxxxxxxxx:oidc-provider/token.actions.githubusercontent.com]
aws_iam_policy.iam_policy: Creation complete after 0s [id=arn:aws:iam::xxxxxxxxxxxxxx:policy/github_oidc_terraform-dev20220512182828671900000001]
module.iam_assumable_role_admin.aws_iam_role.this[0]: Creation complete after 1s [id=github_oidc_terraform-dev]
module.iam_assumable_role_admin.aws_iam_role_policy_attachment.custom[0]: Creating...
module.iam_assumable_role_admin.aws_iam_role_policy_attachment.custom[0]: Creation complete after 0s [id=github_oidc_terraform-dev-20220512182829972200000002]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

arn = "arn:aws:iam::xxxxxxxxxxxxxx:role/github_oidc_terraform-dev"
```

The output will be used in the Github Action workflow file as an input
to assuming the role.  This will have to be manually done.

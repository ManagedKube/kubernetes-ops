## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_assume_role_policy"></a> [iam\_assume\_role\_policy](#input\_iam\_assume\_role\_policy) | Json to create assume\_role\_policy in line | `string` | `"{}"` | no |
| <a name="input_iam_description"></a> [iam\_description](#input\_iam\_description) | (Optional) Description of the role. | `string` | `"New Role created from ManagedKube Module"` | no |
| <a name="input_iam_force_detach_policies"></a> [iam\_force\_detach\_policies](#input\_iam\_force\_detach\_policies) | (Optional) Whether to force detaching any policies the role has before destroying it | `bool` | `false` | no |
| <a name="input_iam_inline_policy"></a> [iam\_inline\_policy](#input\_iam\_inline\_policy) | Json to create policy in line | `string` | `"{}"` | no |
| <a name="input_iam_managed_policy_arns"></a> [iam\_managed\_policy\_arns](#input\_iam\_managed\_policy\_arns) | List of arn policies to attached | `list(string)` | `[]` | no |
| <a name="input_iam_max_session_duration"></a> [iam\_max\_session\_duration](#input\_iam\_max\_session\_duration) | (Optional) Maximum session duration (in seconds) that you want to set for the specified role his setting can have a value from 1 hour to 12 hours. | `number` | `3600` | no |
| <a name="input_iam_name"></a> [iam\_name](#input\_iam\_name) | Friendly name of the role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of tags for the IAM role. If configured with a provider | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_arn"></a> [iam\_arn](#output\_iam\_arn) | Amazon Resource Name (ARN) specifying the role. |


## How to use the module?
1. Input values
  ```
iam_name                  = local.iam_rolename
  iam_description           = local.iam_description
  iam_force_detach_policies = true
  iam_managed_policy_arns   = ["arn:aws:iam::aws:policy/ReadOnlyAccess"] #you can add more than one policy
  iam_assume_role_policy    = templatefile("assume_role_policy.json", { some parameters}) # This json is for the trusted policy
  iam_inline_policy         = templatefile("prowler-additions-plus-s3-policy.json", {}) # You can add in line policy created by you
  tags                      = local.tags
```

2. Terraform Apply Log
```
aws-vault exec exact-ops -- terragrunt apply
Acquiring state lock. This may take a few moments...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Condition = {
                          + StringEquals = {
                              + sts:ExternalId = "xxxxxxxxxx"
                            }
                        }
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = "arn:aws:iam::xxxxxxxx:root"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "x2-ops-tenable-scan: Specific read-only role for tenable scans in aws account"
      + force_detach_policies = true
      + id                    = (known after apply)
      + managed_policy_arns   = [
          + "arn:aws:iam::aws:policy/ReadOnlyAccess",
        ]
      + max_session_duration  = 3600
      + name                  = "x2-ops-tenable-scan"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "ops_env"              = "ops"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "gruntwork-infrastructure-live"
          + "ops_source_repo_path" = "xxxx/tenable-scan"
        }
      + tags_all              = {
          + "ops_env"              = "ops"
          + "ops_managed_by"       = "terraform"
          + "ops_owners"           = "devops"
          + "ops_source_repo"      = "xxxxxx"
          + "ops_source_repo_path" = "xxxxxxx/tenable-scan"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = "x2-ops-tenable-scan"
          + policy = jsonencode(
                {
                  + Statement = [
                      + {
                          + Action   = [
                              + "s3:ListBucket",
                            ]
                          + Effect   = "Allow"
                          + Resource = [
                              + "arn:aws:s3:::testing",
                            ]
                        },
                      + {
                          + Action   = [
                              + "s3:PutObject",
                              + "s3:GetObject",
                              + "s3:DeleteObject",
                              + "s3:PutObjectAcl",
                            ]
                          + Effect   = "Allow"
                          + Resource = [
                              + "arn:aws:s3:::testing/*",
                            ]
                        },
                      + {
                          + Action   = [
                              + "ds:Get*",
                              + "ds:Describe*",
                              + "ds:List*",
                              + "ec2:GetEbsEncryptionByDefault",
                              + "ecr:Describe*",
                              + "elasticfilesystem:DescribeBackupPolicy",
                              + "glue:GetConnections",
                              + "glue:GetSecurityConfiguration",
                              + "glue:SearchTables",
                              + "lambda:GetFunction",
                              + "s3:GetAccountPublicAccessBlock",
                              + "shield:DescribeProtection",
                              + "shield:GetSubscriptionState",
                              + "ssm:GetDocument",
                              + "support:Describe*",
                              + "tag:GetTagKeys",
                            ]
                          + Effect   = "Allow"
                          + Resource = "*"
                          + Sid      = "AllowMoreReadForProwler"
                        },
                      + {
                          + Action   = [
                              + "apigateway:GET",
                            ]
                          + Effect   = "Allow"
                          + Resource = [
                              + "arn:aws:apigateway:*::/restapis/*",
                            ]
                        },
                    ]
                  + Version   = "2012-10-17"
                }
            )
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + iam_arn = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_iam_role.this: Creating...
aws_iam_role.this: Creation complete after 2s [id=x2-ops-tenable-scan]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Releasing state lock. This may take a few moments...

Outputs:

iam_arn = "arn:aws:iam::xxxxxxx:role/x2-ops-tenable-scan"
```

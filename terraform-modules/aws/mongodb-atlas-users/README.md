## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | 1.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | 1.0.1 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [mongodbatlas_database_user.admin](https://registry.terraform.io/providers/mongodb/mongodbatlas/1.0.1/docs/resources/database_user) | resource |
| [mongodbatlas_database_user.test](https://registry.terraform.io/providers/mongodb/mongodbatlas/1.0.1/docs/resources/database_user) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_secret_description"></a> [aws\_secret\_description](#input\_aws\_secret\_description) | The aws secret description | `string` | `""` | no |
| <a name="input_aws_secret_name"></a> [aws\_secret\_name](#input\_aws\_secret\_name) | The name for the AWS secret | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster as it appears in Atlas. | `string` | n/a | yes |
| <a name="input_create_aws_secret"></a> [create\_aws\_secret](#input\_create\_aws\_secret) | To create an AWS secret or not | `bool` | `false` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The IAM Role name to assign an auth user to the DB | `string` | n/a | yes |
| <a name="input_mongodbatlas_projectid"></a> [mongodbatlas\_projectid](#input\_mongodbatlas\_projectid) | The unique ID for the project to create the database user. | `string` | n/a | yes |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30. | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of Tags | `map(any)` | n/a | yes |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | The password for the user | `string` | `null` | no |

## Outputs

No outputs.

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
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | A boolean flag to indicate whether to create a KMS key or not | `bool` | `false` | no |
| <a name="input_secretsmanager_kms_deletion_window_in_days"></a> [secretsmanager\_kms\_deletion\_window\_in\_days](#input\_secretsmanager\_kms\_deletion\_window\_in\_days) | The number of days to wait before deleting the KMS key | `number` | `30` | no |
| <a name="input_secretsmanager_kms_name"></a> [secretsmanager\_kms\_name](#input\_secretsmanager\_kms\_name) | The display name of the KMS key | `string` | `""` | no |
| <a name="input_secretsmanager_secret_description"></a> [secretsmanager\_secret\_description](#input\_secretsmanager\_secret\_description) | The description of the Secrets Manager secret | `string` | `""` | no |
| <a name="input_secretsmanager_secret_name"></a> [secretsmanager\_secret\_name](#input\_secretsmanager\_secret\_name) | The name of the Secrets Manager secret | `string` | n/a | yes |
| <a name="input_secretsmanager_secret_name_prefix"></a> [secretsmanager\_secret\_name\_prefix](#input\_secretsmanager\_secret\_name\_prefix) | A prefix for the Secrets Manager secret name | `string` | `""` | no |
| <a name="input_secretsmanager_secret_recovery_window_in_days"></a> [secretsmanager\_secret\_recovery\_window\_in\_days](#input\_secretsmanager\_secret\_recovery\_window\_in\_days) | The number of days to wait before deleting the Secrets Manager secret | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the KMS key |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The globally unique identifier for the KMS key |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the Secrets Manager secret |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | ARN of the Secrets Manager secret |

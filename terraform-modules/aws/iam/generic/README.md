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
| <a name="input_iam_description"></a> [iam\_description](#input\_iam\_description) | (Optional) Description of the role. | `string` | `"New Role created from ManagedKube Module"` | no |
| <a name="input_iam_force_detach_policies"></a> [iam\_force\_detach\_policies](#input\_iam\_force\_detach\_policies) | (Optional) Whether to force detaching any policies the role has before destroying it | `bool` | `false` | no |
| <a name="input_iam_inline_policy"></a> [iam\_inline\_policy](#input\_iam\_inline\_policy) | Json to create policy in line | `string` | `"{}"` | no |
| <a name="input_iam_managed_policy_arns"></a> [iam\_managed\_policy\_arns](#input\_iam\_managed\_policy\_arns) | List of arn policies to attached | `list(string)` | `[]` | no |
| <a name="input_iam_max_session_duration"></a> [iam\_max\_session\_duration](#input\_iam\_max\_session\_duration) | (Optional) Maximum session duration (in seconds) that you want to set for the specified role his setting can have a value from 1 hour to 12 hours. | `number` | `60` | no |
| <a name="input_iam_name"></a> [iam\_name](#input\_iam\_name) | Friendly name of the role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of tags for the IAM role. If configured with a provider | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_arn"></a> [iam\_arn](#output\_iam\_arn) | Amazon Resource Name (ARN) specifying the role. |

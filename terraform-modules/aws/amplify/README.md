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
| [aws_amplify_app.amplify](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_app) | resource |
| [aws_amplify_branch.deploy_branches](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_branch) | resource |
| [aws_amplify_domain_association.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_domain_association) | resource |
| [aws_iam_role.amplify](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.role_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_name"></a> [branch\_name](#input\_branch\_name) | The branch name to be deployed. | `string` | `null` | no |
| <a name="input_build_spec"></a> [build\_spec](#input\_build\_spec) | Build spec for the Amplify App | `string` | `null` | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | Custom rules for the AWS Amplify App | <pre>list(object({<br>    source    = string<br>    target    = string<br>    status    = string<br>  }))</pre> | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to associate with the Amplify app. | `string` | `null` | no |
| <a name="input_enable_branch_auto_build"></a> [enable\_branch\_auto\_build](#input\_enable\_branch\_auto\_build) | Enable branch auto-build for the Amplify App | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the Amplify App | `map(string)` | `{}` | no |
| <a name="input_gh_access_token"></a> [gh\_access\_token](#input\_gh\_access\_token) | GitHub access token for the Amplify App | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Amplify App | `string` | `null` | no |
| <a name="input_repository_url"></a> [repository\_url](#input\_repository\_url) | The URL of the Git repository for the Amplify App | `string` | n/a | yes |
| <a name="input_sub_domain_branch"></a> [sub\_domain\_branch](#input\_sub\_domain\_branch) | The branch name to associate with the subdomain. | `string` | `null` | no |
| <a name="input_sub_domain_prefix"></a> [sub\_domain\_prefix](#input\_sub\_domain\_prefix) | The subdomain prefix to associate with the branch. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A set of tags to place on the items | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amplify_app_arn"></a> [amplify\_app\_arn](#output\_amplify\_app\_arn) | The ARN of the created Amplify App |
| <a name="output_amplify_app_default_domain"></a> [amplify\_app\_default\_domain](#output\_amplify\_app\_default\_domain) | The default domain of the created Amplify App |
| <a name="output_amplify_app_id"></a> [amplify\_app\_id](#output\_amplify\_app\_id) | The ID of the created Amplify App |
| <a name="output_amplify_app_name"></a> [amplify\_app\_name](#output\_amplify\_app\_name) | The name of the created Amplify App |

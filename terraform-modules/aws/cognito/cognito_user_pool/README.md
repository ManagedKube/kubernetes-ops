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
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the user pool. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the user pool. |
| <a name="output_creation_date"></a> [creation\_date](#output\_creation\_date) | Date the user pool was created. |
| <a name="output_custom_domain"></a> [custom\_domain](#output\_custom\_domain) | A custom domain name that you provide to Amazon Cognito. |
| <a name="output_domain"></a> [domain](#output\_domain) | Holds the domain prefix if the user pool has a domain associated with it. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint name of the user pool. |
| <a name="output_estimated_number_of_users"></a> [estimated\_number\_of\_users](#output\_estimated\_number\_of\_users) | A number estimating the size of the user pool. |
| <a name="output_id"></a> [id](#output\_id) | ID of the user pool. |

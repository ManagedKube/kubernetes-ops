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
| [aws_vpc_endpoint.execute_api_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Enable private DNS for the VPC endpoint | `bool` | `true` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of the security group to associate with the VPC endpoint | `any` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service name for the VPC endpoint | `any` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the VPC endpoint will be deployed | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_vpc_endpoint_type"></a> [vpc\_endpoint\_type](#input\_vpc\_endpoint\_type) | Type of VPC endpoint | `string` | `"Interface"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the VPC endpoint will be created | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execute_api_endpoint_id"></a> [execute\_api\_endpoint\_id](#output\_execute\_api\_endpoint\_id) | n/a |

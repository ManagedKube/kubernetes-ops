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
| [aws_api_gateway_vpc_link.apivpclink](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_vpc_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_vpc_link_description"></a> [vpc\_link\_description](#input\_vpc\_link\_description) | Description of the API Gateway VPC link | `any` | n/a | yes |
| <a name="input_vpc_link_name"></a> [vpc\_link\_name](#input\_vpc\_link\_name) | Name of the API Gateway VPC link | `any` | n/a | yes |
| <a name="input_vpc_link_nbl_arn"></a> [vpc\_link\_nbl\_arn](#input\_vpc\_link\_nbl\_arn) | ARN of the NLB VPC link | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_vpc_link_id"></a> [api\_gateway\_vpc\_link\_id](#output\_api\_gateway\_vpc\_link\_id) | n/a |

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
| [aws_lb.apivpclinknlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_internal_lb"></a> [internal\_lb](#input\_internal\_lb) | Flag to indicate if the load balancer is internal (true/false) | `bool` | n/a | yes |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name of the load balancer | `any` | n/a | yes |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of load balancer | `any` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet for the load balancer | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_vpc_link_description"></a> [vpc\_link\_description](#input\_vpc\_link\_description) | Description of the API Gateway VPC link | `any` | n/a | yes |
| <a name="input_vpc_link_name"></a> [vpc\_link\_name](#input\_vpc\_link\_name) | Name of the API Gateway VPC link | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_vpc_link_id"></a> [api\_gateway\_vpc\_link\_id](#output\_api\_gateway\_vpc\_link\_id) | n/a |

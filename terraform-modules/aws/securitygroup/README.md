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
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the security group | `string` | n/a | yes |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | A list of egress rules to apply to the security group | <pre>list(object({<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A list of ingress rules to apply to the security group | <pre>list(object({<br>    description      = string<br>    from_port        = number<br>    to_port          = number<br>    protocol         = string<br>    cidr_blocks      = list(string)<br>    ipv6_cidr_blocks = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the security group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags | `map(any)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which to create the security group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the security group. |
| <a name="output_id"></a> [id](#output\_id) | ID of the security group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the security group |

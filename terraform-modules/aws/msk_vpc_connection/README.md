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
| [aws_msk_vpc_connection.vc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_vpc_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_msk_arn"></a> [msk\_arn](#input\_msk\_arn) | ARN of the existing MSK cluster | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of IDs of existing security groups | `list(string)` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of IDs of existing subnets | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_msk_vpc_connection_arn"></a> [msk\_vpc\_connection\_arn](#output\_msk\_vpc\_connection\_arn) | ARN of the created AWS MSK VPC Connection |

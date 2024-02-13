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
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The service name for the VPC endpoint | `any` | n/a | yes |
| <a name="input_vpc_endpoint_type"></a> [vpc\_endpoint\_type](#input\_vpc\_endpoint\_type) | The type of VPC endpoint to create | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which to create the VPC endpoint | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_entry"></a> [dns\_entry](#output\_dns\_entry) | Represents the fully qualified domain name (FQDN) of the VPC endpoint. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | Represents the DNS name for the VPC endpoint service. |

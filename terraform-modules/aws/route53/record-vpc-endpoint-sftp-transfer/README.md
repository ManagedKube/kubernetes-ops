## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_record"></a> [record](#module\_record) | ../record/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_transfer_server.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/transfer_server) | data source |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | whether or not Route 53 should perform health checks on the target of an alias record before responding to DNS queries. | `bool` | `false` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | The name for the Route 53 record. | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The ID of the Route 53 zone where the record will be created. | `string` | n/a | yes |
| <a name="input_transfer_server_id"></a> [transfer\_server\_id](#input\_transfer\_server\_id) | The ID of the AWS Transfer Server | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | Also known as an Address record, is used to map a domain name to an IP address. | `string` | `"A"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID Where VPC enpoint is configured | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | FQDN built using the zone domain and name. |
| <a name="output_name"></a> [name](#output\_name) | The name for the Route 53 record. |
| <a name="output_vpc_endpoint_dns_entry"></a> [vpc\_endpoint\_dns\_entry](#output\_vpc\_endpoint\_dns\_entry) | Retrieve the DNS name associated with an AWS VPC Endpoint. |
| <a name="output_vpc_endpoint_dns_name"></a> [vpc\_endpoint\_dns\_name](#output\_vpc\_endpoint\_dns\_name) | Retrieves the primary DNS name associated with the VPC Endpoint |
| <a name="output_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#output\_vpc\_endpoint\_id) | ID of an AWS VPC Endpoint |

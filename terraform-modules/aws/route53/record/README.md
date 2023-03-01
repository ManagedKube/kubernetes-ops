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
| [aws_route53_record.example_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | whether or not Route 53 should perform health checks on the target of an alias record before responding to DNS queries. | `bool` | `false` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | FQDN built using the zone domain and name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name for the Route 53 record. | `string` | n/a | yes |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | The name for the Route 53 record. | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The ID of the Route 53 zone where the record will be created. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Also known as an Address record, is used to map a domain name to an IP address. | `string` | `"A"` | no |
| <a name="input_vpc_endpoint_dns_name"></a> [vpc\_endpoint\_dns\_name](#input\_vpc\_endpoint\_dns\_name) | The DNS name of the VPC Endpoint. | `string` | n/a | yes |
| <a name="input_vpc_endpoint_zone_id"></a> [vpc\_endpoint\_zone\_id](#input\_vpc\_endpoint\_zone\_id) | The ID of the Hosted Zone for the VPC Endpoint. | `string` | n/a | yes |

## Outputs

No outputs.

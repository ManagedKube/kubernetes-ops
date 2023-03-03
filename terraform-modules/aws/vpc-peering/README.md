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
| [aws_route_table_association.association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.endpoint_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_peering_connection.peering_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Specifies whether DNS resolution is enabled for the VPC peering connection | `bool` | `true` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Specifies whether the peering connection should be automatically accepted | `bool` | `true` | no |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | ID of the VPC B | `string` | n/a | yes |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Specifies whether DNS resolution is enabled for the VPC peering connection | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs for which to retrieve the associated route tables | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the VPC peering connection | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the subnets are located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_route_table_association_id"></a> [aws\_route\_table\_association\_id](#output\_aws\_route\_table\_association\_id) | The ID of the association |
| <a name="output_aws_vpc_endpoint_route_table_association_id"></a> [aws\_vpc\_endpoint\_route\_table\_association\_id](#output\_aws\_vpc\_endpoint\_route\_table\_association\_id) | A hash of the EC2 Route Table and VPC Endpoint identifiers. |
| <a name="output_vpc_peering_connection_accept_status"></a> [vpc\_peering\_connection\_accept\_status](#output\_vpc\_peering\_connection\_accept\_status) | The status of the VPC Peering Connection request |
| <a name="output_vpc_peering_connection_id"></a> [vpc\_peering\_connection\_id](#output\_vpc\_peering\_connection\_id) | The ID of the VPC Peering Connection |

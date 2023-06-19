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
| [aws_wafv2_ip_set.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_address_version"></a> [ip\_address\_version](#input\_ip\_address\_version) | (Required) Specify IPV4 or IPV6. Valid values are IPV4 or IPV6. | `string` | `"IPV4"` | no |
| <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses) | A list of IP addresses in CIDR notation to include in the IP set. | `list(string)` | n/a | yes |
| <a name="input_ip_set_description"></a> [ip\_set\_description](#input\_ip\_set\_description) | A description of the IP set. | `string` | n/a | yes |
| <a name="input_ip_set_name"></a> [ip\_set\_name](#input\_ip\_set\_name) | The name of the IP set. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the Region US East (N. Virginia). | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the IP set. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the IP set. |
| <a name="output_id"></a> [id](#output\_id) | A unique identifier for the IP set. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the IP set, including those inherited from the provider default\_tags configuration block. |

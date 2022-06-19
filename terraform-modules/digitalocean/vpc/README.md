<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | 2.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_vpc.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_description"></a> [vpc\_description](#input\_vpc\_description) | (Optional) A free-form text field up to a limit of 255 characters to describe the VPC. | `string` | `"Your new vpc"` | no |
| <a name="input_vpc_ip_range"></a> [vpc\_ip\_range](#input\_vpc\_ip\_range) | (Optional) The range of IP addresses for the VPC in CIDR notation. | `string` | `"10.10.10.0/24"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | (Required) A name for the VPC. Must be unique and contain alphanumeric characters, dashes, and periods only. | `string` | n/a | yes |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | (Required) The DigitalOcean region slug for the VPC's location. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_default"></a> [vpc\_default](#output\_vpc\_default) | A boolean indicating whether or not the VPC is the default one for the region. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The unique identifier for the VPC. |
| <a name="output_vpc_urn"></a> [vpc\_urn](#output\_vpc\_urn) | The uniform resource name (URN) for the VPC. |
<!-- END_TF_DOCS -->
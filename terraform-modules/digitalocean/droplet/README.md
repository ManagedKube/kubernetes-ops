# Droplet
Docs: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet

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
| [digitalocean_droplet.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/droplet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_droplet_image"></a> [droplet\_image](#input\_droplet\_image) | (Required) The Droplet image ID or slug | `string` | n/a | yes |
| <a name="input_droplet_monitoring"></a> [droplet\_monitoring](#input\_droplet\_monitoring) | (Optional) Boolean controlling whether monitoring agent is installed. Defaults to false. If set to true, you can configure monitor alert policies monitor alert | `bool` | `false` | no |
| <a name="input_droplet_name"></a> [droplet\_name](#input\_droplet\_name) | (Required) The Droplet name. | `string` | n/a | yes |
| <a name="input_droplet_region"></a> [droplet\_region](#input\_droplet\_region) | (Required) The region to start in. | `string` | n/a | yes |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | (Required) The unique slug that indentifies the type of Droplet. You can find a list of available slugs on DigitalOcean API documentation. | `string` | n/a | yes |
| <a name="input_droplet_user_data"></a> [droplet\_user\_data](#input\_droplet\_user\_data) | (Optional) A string of the desired User Data for the Droplet. | `string` | n/a | yes |
| <a name="input_droplet_vpc_uuid"></a> [droplet\_vpc\_uuid](#input\_droplet\_vpc\_uuid) | The ID of the VPC where the Droplet will be located. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplet_id"></a> [droplet\_id](#output\_droplet\_id) | The ID of the Droplet |
| <a name="output_droplet_urn"></a> [droplet\_urn](#output\_droplet\_urn) | The uniform resource name of the Droplet |
<!-- END_TF_DOCS -->
# Attach Volume to Droplet
Docs: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/volume_attachment

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
| [digitalocean_volume_attachment.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/volume_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_droplet_id"></a> [droplet\_id](#input\_droplet\_id) | (Required) ID of the Droplet to attach the volume to. | `string` | n/a | yes |
| <a name="input_volume_id"></a> [volume\_id](#input\_volume\_id) | (Required) ID of the Volume to be attached to the Droplet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplet_volume_attachment"></a> [droplet\_volume\_attachment](#output\_droplet\_volume\_attachment) | The unique identifier for the volume attachment. |
<!-- END_TF_DOCS -->
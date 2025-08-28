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
| [digitalocean_project_resources.project](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/project_resources) | resource |
| [digitalocean_volume.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_volume_description"></a> [volume\_description](#input\_volume\_description) | (Optional) A free-form text field up to a limit of 1024 bytes to describe a block storage volume.. | `string` | n/a | yes |
| <a name="input_volume_initial_filesystem_type"></a> [volume\_initial\_filesystem\_type](#input\_volume\_initial\_filesystem\_type) | (Optional) Initial filesystem type (xfs or ext4) for the block storage volume. | `string` | n/a | yes |
| <a name="input_volume_name"></a> [volume\_name](#input\_volume\_name) | (Required) A name for the block storage volume. Must be lowercase and be composed only of numbers, letters and -, up to a limit of 64 characters. | `string` | n/a | yes |
| <a name="input_volume_project_id"></a> [volume\_project\_id](#input\_volume\_project\_id) | (Optional) The id of the project where the volume will be associated | `string` | n/a | yes |
| <a name="input_volume_region"></a> [volume\_region](#input\_volume\_region) | (Required) The region that the block storage volume will be created in. | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Required) The size of the block storage volume in GiB. If updated, can only be expanded. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_volume_id"></a> [volume\_id](#output\_volume\_id) | The unique identifier for the volume. |
| <a name="output_volume_urn"></a> [volume\_urn](#output\_volume\_urn) | The uniform resource name for the volume. |
<!-- END_TF_DOCS -->
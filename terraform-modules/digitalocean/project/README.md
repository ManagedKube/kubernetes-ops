## Description
The module is capable of creating a project to group a set of digital ocean resources

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| digitalocean_project | [registry.terraform.io/providers/digitalocean/project](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project) | 2.19.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | `"The name of the project"` | `string` | `"playground"` | yes |
| `project_description` | `"The name of description"` | `string` | `"A project to represent development resources."` | no |
| `project_purpose` | `"A purpose for the project"` | `string` | `"Web Application"` | no |
| `project_environment` | `"Kind of dev, qa or prod"` | `string` | `"development"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `project_id` | The id of the project |
| `project_owner_uuid` | the unique universal identifier of the project owner. |

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
| [digitalocean_project.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.19.0/docs/resources/project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_description"></a> [project\_description](#input\_project\_description) | (Optional) The name of description | `string` | `"A project to represent development resources."` | no |
| <a name="input_project_environment"></a> [project\_environment](#input\_project\_environment) | (Optional) Kind of dev, qa or prod | `string` | `"development"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Required) The name of the project | `string` | `"playground"` | no |
| <a name="input_project_purpose"></a> [project\_purpose](#input\_project\_purpose) | (Optional) A purpose for the project | `string` | `"Web Application"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The id of the project |
| <a name="output_project_owner_uuid"></a> [project\_owner\_uuid](#output\_project\_owner\_uuid) | The unique universal identifier of the project owner. |
<!-- END_TF_DOCS -->
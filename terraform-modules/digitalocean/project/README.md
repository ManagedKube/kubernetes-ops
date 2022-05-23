## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="digitalocean_project"></a> [project](#module\digitalocean_project) | [terraform-aws-modules/vpc/aws](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project) | x.x.x |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="project_name"></a>| `"The name of the project"` | `string` | `"playground"` | yes |
| <a name="project_description"></a>| `"The name of description"` | `string` | `"A project to represent development resources."` | no |
| <a name="project_purpose"></a>| `"A purpose for the project"` | `string` | `"Web Application"` | no |
| <a name="project_environment"></a>| `"Kind of dev, qa or prod"` | `string` | `"development"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="project_id"></a> | The id of the project |
| <a name="project_owner_uuid"></a> | the unique universal identifier of the project owner. |

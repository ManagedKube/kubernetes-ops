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
| `project_name` | `"The name of the project"` | `string` | `"playground"` | yes |
| `project_description` | `"The name of description"` | `string` | `"A project to represent development resources."` | no |
| `project_purpose` | `"A purpose for the project"` | `string` | `"Web Application"` | no |
| `project_environment` | `"Kind of dev, qa or prod"` | `string` | `"development"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `project_id` | The id of the project |
| `project_owner_uuid` | the unique universal identifier of the project owner. |

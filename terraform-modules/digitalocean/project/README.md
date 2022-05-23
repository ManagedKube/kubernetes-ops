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

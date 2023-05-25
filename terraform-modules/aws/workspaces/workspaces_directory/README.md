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
| [aws_directory_service_directory.directory_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |
| [aws_iam_role.workspaces_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_self_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.workspaces_default_service_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_workspaces_directory.directory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_directory) | resource |
| [aws_iam_policy_document.workspaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret_version.directory_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_directory_service_directory_edition"></a> [directory\_service\_directory\_edition](#input\_directory\_service\_directory\_edition) | (Optional, for type MicrosoftAD only) The MicrosoftAD edition (Standard or Enterprise). Defaults to Enterprise. | `string` | `"Standard"` | no |
| <a name="input_directory_service_directory_name"></a> [directory\_service\_directory\_name](#input\_directory\_service\_directory\_name) | Name of Directory Service in Directory Name | `string` | n/a | yes |
| <a name="input_directory_service_directory_name_password_secretsmanager_id"></a> [directory\_service\_directory\_name\_password\_secretsmanager\_id](#input\_directory\_service\_directory\_name\_password\_secretsmanager\_id) | The name of the AWS Secrets Manager secret that stores the password for the AWS Managed Microsoft AD directory. | `string` | `""` | no |
| <a name="input_directory_service_directory_size"></a> [directory\_service\_directory\_size](#input\_directory\_service\_directory\_size) | (For SimpleAD and ADConnector types) The size of the directory (Small or Large are accepted values). Small by default. | `string` | `"Small"` | no |
| <a name="input_directory_service_directory_subnet_ids"></a> [directory\_service\_directory\_subnet\_ids](#input\_directory\_service\_directory\_subnet\_ids) | List of subnet IDs to Directory Service | `list(string)` | `[]` | no |
| <a name="input_directory_service_directory_type"></a> [directory\_service\_directory\_type](#input\_directory\_service\_directory\_type) | The directory type (SimpleAD, ADConnector or MicrosoftAD are accepted values). Defaults to SimpleAD. | `string` | `"SimpleAD"` | no |
| <a name="input_directory_service_directory_vpc_id"></a> [directory\_service\_directory\_vpc\_id](#input\_directory\_service\_directory\_vpc\_id) | VPC ID for the AWS Directory Service | `string` | `""` | no |
| <a name="input_directory_service_enable_sso"></a> [directory\_service\_enable\_sso](#input\_directory\_service\_enable\_sso) | Whether to enable single-sign on for the directory. Requires alias. Defaults to false. | `bool` | `false` | no |
| <a name="input_self_service_permissions_change_compute_type"></a> [self\_service\_permissions\_change\_compute\_type](#input\_self\_service\_permissions\_change\_compute\_type) | Allow users to change compute type | `bool` | `true` | no |
| <a name="input_self_service_permissions_increase_volume_size"></a> [self\_service\_permissions\_increase\_volume\_size](#input\_self\_service\_permissions\_increase\_volume\_size) | Allow users to increase volume size | `bool` | `true` | no |
| <a name="input_self_service_permissions_rebuild_workspace"></a> [self\_service\_permissions\_rebuild\_workspace](#input\_self\_service\_permissions\_rebuild\_workspace) | Allow users to rebuild their workspace | `bool` | `true` | no |
| <a name="input_self_service_permissions_restart_workspace"></a> [self\_service\_permissions\_restart\_workspace](#input\_self\_service\_permissions\_restart\_workspace) | Allow users to restart their workspace | `bool` | `true` | no |
| <a name="input_self_service_permissions_switch_running_mode"></a> [self\_service\_permissions\_switch\_running\_mode](#input\_self\_service\_permissions\_switch\_running\_mode) | Allow users to switch running mode | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key-value pairs to assign as tags to the AWS resources created by this Terraform configuration. | `map(any)` | `{}` | no |
| <a name="input_workspace_access_properties_device_type_android"></a> [workspace\_access\_properties\_device\_type\_android](#input\_workspace\_access\_properties\_device\_type\_android) | Access property for Android devices | `string` | `"ALLOW"` | no |
| <a name="input_workspace_access_properties_device_type_chromeos"></a> [workspace\_access\_properties\_device\_type\_chromeos](#input\_workspace\_access\_properties\_device\_type\_chromeos) | Access property for Chrome OS devices | `string` | `"ALLOW"` | no |
| <a name="input_workspace_access_properties_device_type_ios"></a> [workspace\_access\_properties\_device\_type\_ios](#input\_workspace\_access\_properties\_device\_type\_ios) | Access property for iOS devices | `string` | `"ALLOW"` | no |
| <a name="input_workspace_access_properties_device_type_linux"></a> [workspace\_access\_properties\_device\_type\_linux](#input\_workspace\_access\_properties\_device\_type\_linux) | Access property for Linux devices | `string` | `"DENY"` | no |
| <a name="input_workspace_access_properties_device_type_osx"></a> [workspace\_access\_properties\_device\_type\_osx](#input\_workspace\_access\_properties\_device\_type\_osx) | Access property for macOS devices | `string` | `"ALLOW"` | no |
| <a name="input_workspace_access_properties_device_type_web"></a> [workspace\_access\_properties\_device\_type\_web](#input\_workspace\_access\_properties\_device\_type\_web) | Access property for web devices | `string` | `"DENY"` | no |
| <a name="input_workspace_access_properties_device_type_windows"></a> [workspace\_access\_properties\_device\_type\_windows](#input\_workspace\_access\_properties\_device\_type\_windows) | Access property for Windows devices | `string` | `"DENY"` | no |
| <a name="input_workspace_access_properties_device_type_zeroclient"></a> [workspace\_access\_properties\_device\_type\_zeroclient](#input\_workspace\_access\_properties\_device\_type\_zeroclient) | Access property for Zero Client devices | `string` | `"DENY"` | no |
| <a name="input_workspace_creation_properties_custom_security_group_id"></a> [workspace\_creation\_properties\_custom\_security\_group\_id](#input\_workspace\_creation\_properties\_custom\_security\_group\_id) | Custom security group ID for the WorkSpaces | `string` | `""` | no |
| <a name="input_workspace_creation_properties_default_ou"></a> [workspace\_creation\_properties\_default\_ou](#input\_workspace\_creation\_properties\_default\_ou) | Default organizational unit (OU) for WorkSpaces | `string` | `"OU=AWS,DC=Workgroup,DC=Example,DC=com"` | no |
| <a name="input_workspace_creation_properties_enable_internet_access"></a> [workspace\_creation\_properties\_enable\_internet\_access](#input\_workspace\_creation\_properties\_enable\_internet\_access) | Enable internet access for WorkSpaces | `bool` | `true` | no |
| <a name="input_workspace_creation_properties_enable_maintenance_mode"></a> [workspace\_creation\_properties\_enable\_maintenance\_mode](#input\_workspace\_creation\_properties\_enable\_maintenance\_mode) | Enable maintenance mode for WorkSpaces | `bool` | `true` | no |
| <a name="input_workspace_creation_properties_user_enabled_as_local_administrator"></a> [workspace\_creation\_properties\_user\_enabled\_as\_local\_administrator](#input\_workspace\_creation\_properties\_user\_enabled\_as\_local\_administrator) | Enable WorkSpaces users as local administrators | `bool` | `true` | no |
| <a name="input_workspaces_directory_subnet_ids"></a> [workspaces\_directory\_subnet\_ids](#input\_workspaces\_directory\_subnet\_ids) | List of subnet IDs to workspaces directory | `list(string)` | `[]` | no |
| <a name="input_workspaces_ip_group_ids"></a> [workspaces\_ip\_group\_ids](#input\_workspaces\_ip\_group\_ids) | List of Ip Groups IDs to workspaces directory | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_directory_alias"></a> [workspace\_directory\_alias](#output\_workspace\_directory\_alias) | The directory alias. |
| <a name="output_workspace_directory_customer_user_name"></a> [workspace\_directory\_customer\_user\_name](#output\_workspace\_directory\_customer\_user\_name) | The user name for the service account. |
| <a name="output_workspace_directory_directory_name"></a> [workspace\_directory\_directory\_name](#output\_workspace\_directory\_directory\_name) | The name of the directory. |
| <a name="output_workspace_directory_directory_type"></a> [workspace\_directory\_directory\_type](#output\_workspace\_directory\_directory\_type) | The directory type. |
| <a name="output_workspace_directory_dns_ip_addresses"></a> [workspace\_directory\_dns\_ip\_addresses](#output\_workspace\_directory\_dns\_ip\_addresses) | The IP addresses of the DNS servers for the directory. |
| <a name="output_workspace_directory_iam_role_id"></a> [workspace\_directory\_iam\_role\_id](#output\_workspace\_directory\_iam\_role\_id) | The identifier of the IAM role. |
| <a name="output_workspace_directory_id"></a> [workspace\_directory\_id](#output\_workspace\_directory\_id) | The WorkSpaces directory identifier. |
| <a name="output_workspace_directory_ip_group_ids"></a> [workspace\_directory\_ip\_group\_ids](#output\_workspace\_directory\_ip\_group\_ids) | The identifiers of the IP access control groups associated with the directory. |
| <a name="output_workspace_directory_registration_code"></a> [workspace\_directory\_registration\_code](#output\_workspace\_directory\_registration\_code) | The registration code for the directory. |
| <a name="output_workspace_directory_tags_all"></a> [workspace\_directory\_tags\_all](#output\_workspace\_directory\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_workspace_directory_workspace_security_group_id"></a> [workspace\_directory\_workspace\_security\_group\_id](#output\_workspace\_directory\_workspace\_security\_group\_id) | The identifier of the security group that is assigned to new WorkSpaces. |

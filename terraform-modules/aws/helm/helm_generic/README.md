# helm chart - helm_generic

This is a generic Terraform Helm module usage where a user can plug any chart into it.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.helm_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | n/a | `bool` | `false` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | n/a | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it doesnt exist | `bool` | `true` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | n/a | `bool` | `false` | no |
| <a name="input_devel"></a> [devel](#input\_devel) | n/a | `any` | `null` | no |
| <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation) | n/a | `bool` | `false` | no |
| <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks) | n/a | `bool` | `false` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | n/a | `bool` | `false` | no |
| <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values) | Additional helm values to pass in.  These values would override the default in this module. | `string` | `""` | no |
| <a name="input_helm_values_2"></a> [helm\_values\_2](#input\_helm\_values\_2) | Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm\_values input | `string` | `""` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | Helm chart version | `string` | `"x.x.x"` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | n/a | `any` | `null` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | n/a | `bool` | `false` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | n/a | `number` | `0` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to install in | `string` | `"monitoring"` | no |
| <a name="input_official_chart_name"></a> [official\_chart\_name](#input\_official\_chart\_name) | This is the official chart name that the source names it as.  This will be used for pulling the chart. | `string` | `"generic"` | no |
| <a name="input_pass_credentials"></a> [pass\_credentials](#input\_pass\_credentials) | n/a | `bool` | `false` | no |
| <a name="input_postrender"></a> [postrender](#input\_postrender) | n/a | `any` | `null` | no |
| <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods) | n/a | `bool` | `false` | no |
| <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes) | n/a | `bool` | `true` | no |
| <a name="input_replace"></a> [replace](#input\_replace) | n/a | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The URL to the helm chart | `string` | `"https://example.com"` | no |
| <a name="input_repository_ca_file"></a> [repository\_ca\_file](#input\_repository\_ca\_file) | n/a | `any` | `null` | no |
| <a name="input_repository_cert_file"></a> [repository\_cert\_file](#input\_repository\_cert\_file) | n/a | `any` | `null` | no |
| <a name="input_repository_key_file"></a> [repository\_key\_file](#input\_repository\_key\_file) | n/a | `any` | `null` | no |
| <a name="input_repository_password"></a> [repository\_password](#input\_repository\_password) | n/a | `any` | `null` | no |
| <a name="input_repository_username"></a> [repository\_username](#input\_repository\_username) | n/a | `any` | `null` | no |
| <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values) | n/a | `bool` | `false` | no |
| <a name="input_set"></a> [set](#input\_set) | n/a | `any` | `null` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | n/a | `any` | `null` | no |
| <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds) | n/a | `bool` | `false` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `number` | `300` | no |
| <a name="input_user_chart_name"></a> [user\_chart\_name](#input\_user\_chart\_name) | This is the chart name that the user wants to deploy the chart as | `string` | `"my-chart-name"` | no |
| <a name="input_verify"></a> [verify](#input\_verify) | Verify the helm download | `bool` | `false` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | n/a | `bool` | `true` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chart"></a> [chart](#output\_chart) | n/a |
| <a name="output_status"></a> [status](#output\_status) | n/a |

# helm chart - helm_generic

This is a generic Terraform Helm module usage where a user can plug any chart into it.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- <a name="provider_helm"></a> [helm](#provider\_helm)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [helm_release.helm_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_atomic"></a> [atomic](#input\_atomic)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace)

Description: Create the namespace if it doesnt exist

Type: `bool`

Default: `true`

### <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_devel"></a> [devel](#input\_devel)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_force_update"></a> [force\_update](#input\_force\_update)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values)

Description: Additional helm values to pass in.  These values would override the default in this module.

Type: `string`

Default: `""`

### <a name="input_helm_values_2"></a> [helm\_values\_2](#input\_helm\_values\_2)

Description: Additional helm values to pass in.  These values would override the default in this module and would overwrite the helm\_values input

Type: `string`

Default: `""`

### <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version)

Description: Helm chart version

Type: `string`

Default: `"x.x.x"`

### <a name="input_keyring"></a> [keyring](#input\_keyring)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_lint"></a> [lint](#input\_lint)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_max_history"></a> [max\_history](#input\_max\_history)

Description: n/a

Type: `number`

Default: `0`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: Namespace to install in

Type: `string`

Default: `"monitoring"`

### <a name="input_official_chart_name"></a> [official\_chart\_name](#input\_official\_chart\_name)

Description: This is the official chart name that the source names it as.  This will be used for pulling the chart.

Type: `string`

Default: `"generic"`

### <a name="input_pass_credentials"></a> [pass\_credentials](#input\_pass\_credentials)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_postrender"></a> [postrender](#input\_postrender)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_replace"></a> [replace](#input\_replace)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_repository"></a> [repository](#input\_repository)

Description: The URL to the helm chart

Type: `string`

Default: `"https://example.com"`

### <a name="input_repository_ca_file"></a> [repository\_ca\_file](#input\_repository\_ca\_file)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_repository_cert_file"></a> [repository\_cert\_file](#input\_repository\_cert\_file)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_repository_key_file"></a> [repository\_key\_file](#input\_repository\_key\_file)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_repository_password"></a> [repository\_password](#input\_repository\_password)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_repository_username"></a> [repository\_username](#input\_repository\_username)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_set"></a> [set](#input\_set)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive)

Description: n/a

Type: `any`

Default: `null`

### <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds)

Description: n/a

Type: `bool`

Default: `false`

### <a name="input_timeout"></a> [timeout](#input\_timeout)

Description: n/a

Type: `number`

Default: `300`

### <a name="input_user_chart_name"></a> [user\_chart\_name](#input\_user\_chart\_name)

Description: This is the chart name that the user wants to deploy the chart as

Type: `string`

Default: `"my-chart-name"`

### <a name="input_verify"></a> [verify](#input\_verify)

Description: Verify the helm download

Type: `bool`

Default: `false`

### <a name="input_wait"></a> [wait](#input\_wait)

Description: n/a

Type: `bool`

Default: `true`

### <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs)

Description: n/a

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_chart"></a> [chart](#output\_chart)

Description: n/a

### <a name="output_status"></a> [status](#output\_status)

Description: n/a

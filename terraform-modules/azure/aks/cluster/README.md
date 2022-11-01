## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | n/a | `list(string)` | <pre>[<br>  "1.1.1.1/32"<br>]</pre> | no |
| <a name="input_auto_scaler_balance_similar_node_groups"></a> [auto\_scaler\_balance\_similar\_node\_groups](#input\_auto\_scaler\_balance\_similar\_node\_groups) | n/a | `bool` | `false` | no |
| <a name="input_auto_scaler_expander"></a> [auto\_scaler\_expander](#input\_auto\_scaler\_expander) | n/a | `string` | `"least-waste"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"dev"` | no |
| <a name="input_default_node_pool_enable_auto_scaling"></a> [default\_node\_pool\_enable\_auto\_scaling](#input\_default\_node\_pool\_enable\_auto\_scaling) | n/a | `bool` | `true` | no |
| <a name="input_default_node_pool_enable_host_encryption"></a> [default\_node\_pool\_enable\_host\_encryption](#input\_default\_node\_pool\_enable\_host\_encryption) | n/a | `bool` | `true` | no |
| <a name="input_default_node_pool_instance_size"></a> [default\_node\_pool\_instance\_size](#input\_default\_node\_pool\_instance\_size) | n/a | `string` | `"Standard_B2s"` | no |
| <a name="input_default_node_pool_max_count"></a> [default\_node\_pool\_max\_count](#input\_default\_node\_pool\_max\_count) | n/a | `number` | `1` | no |
| <a name="input_default_node_pool_min_count"></a> [default\_node\_pool\_min\_count](#input\_default\_node\_pool\_min\_count) | n/a | `number` | `1` | no |
| <a name="input_default_node_pool_name"></a> [default\_node\_pool\_name](#input\_default\_node\_pool\_name) | n/a | `string` | `"default"` | no |
| <a name="input_default_node_pool_node_count"></a> [default\_node\_pool\_node\_count](#input\_default\_node\_pool\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_default_node_pool_node_labels"></a> [default\_node\_pool\_node\_labels](#input\_default\_node\_pool\_node\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_default_node_pool_node_taints"></a> [default\_node\_pool\_node\_taints](#input\_default\_node\_pool\_node\_taints) | n/a | `list(string)` | `[]` | no |
| <a name="input_default_node_pool_os_disk_size_gb"></a> [default\_node\_pool\_os\_disk\_size\_gb](#input\_default\_node\_pool\_os\_disk\_size\_gb) | n/a | `string` | `"30"` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | n/a | `string` | `"dev"` | no |
| <a name="input_enable_pod_security_policy"></a> [enable\_pod\_security\_policy](#input\_enable\_pod\_security\_policy) | n/a | `bool` | `false` | no |
| <a name="input_kube_dashboard_enabled"></a> [kube\_dashboard\_enabled](#input\_kube\_dashboard\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `"1.24.3"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"eastus2"` | no |
| <a name="input_network_profile_network_plugin"></a> [network\_profile\_network\_plugin](#input\_network\_profile\_network\_plugin) | n/a | `string` | `"kubenet"` | no |
| <a name="input_network_profile_network_policy"></a> [network\_profile\_network\_policy](#input\_network\_profile\_network\_policy) | n/a | `string` | `"calico"` | no |
| <a name="input_network_profile_pod_cidr"></a> [network\_profile\_pod\_cidr](#input\_network\_profile\_pod\_cidr) | n/a | `string` | `"10.244.0.0/16"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `"kubernetes-ops-aks"` | no |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Account": "dev",<br>  "Environment": "env",<br>  "Group": "devops",<br>  "Location": "East US 2",<br>  "Name": "dev",<br>  "managed_by": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |

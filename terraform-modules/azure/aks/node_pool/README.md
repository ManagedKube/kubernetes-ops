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
| [azurerm_kubernetes_cluster_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | n/a | `bool` | `true` | no |
| <a name="input_kubernetes_cluster_id"></a> [kubernetes\_cluster\_id](#input\_kubernetes\_cluster\_id) | n/a | `any` | n/a | yes |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | n/a | `number` | `1` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | n/a | `number` | `1` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_node_pool_name"></a> [node\_pool\_name](#input\_node\_pool\_name) | n/a | `string` | `"generic"` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | n/a | `list(string)` | `[]` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | n/a | `string` | `"20"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Account": "dev",<br>  "Environment": "env",<br>  "Group": "devops",<br>  "Location": "East US 2",<br>  "Name": "dev",<br>  "managed_by": "Terraform"<br>}</pre> | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `string` | `"Standard_B2s"` | no |

## Outputs

No outputs.

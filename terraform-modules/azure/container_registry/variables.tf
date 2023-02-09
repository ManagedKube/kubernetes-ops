variable "name" {
    description = "The name of the container registry and used for name prefixes"
    default     = "container_registry"
}

variable "azurerm_resource_group" {
    description = "(Required) The name of the resource group"
    default     = null
}

variable "sku" {
    description = "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
    default     = "Premium"
}

# variable "container_registry_assigned_identity_ids" {
#     description = "(Required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry."
#     type        = list(string)
#     default     = ["xxxxx"]
# }

variable "key_vault_id" {
  description = "(Required) The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created."
}

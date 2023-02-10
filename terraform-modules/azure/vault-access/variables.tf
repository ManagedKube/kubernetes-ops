variable "key_vault_id" {
  description = "(Required) The ID of the Key Vault where the Key should be created. Changing this forces a new resource to be created."
}

variable "access_policy" {
  description = "(Required) A list of access policy"
  type        = any
  default     = [
    {
      object_id = "" # (Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID of a service principal can be fetched from azuread_service_principal.object_id. The object ID must be unique for the list of access policies. Changing this forces a new resource to be created.
      tenant_id = ""
      ## List of available permissions can be found here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy
      certificate_permissions = []
      key_permissions = [
        "Get", "WrapKey", "UnwrapKey"
      ]
      secret_permissions = []
      storage_permissions = []
    }
  ]
}

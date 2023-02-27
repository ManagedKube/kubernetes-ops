variable "namespace" {
  type        = string
  default     = "external-secrets"
  description = "Namespace to install in"
}

variable "secret_store_name" {
  type        = string
  default     = "secretstore-main"
  description = "The secret stores name"
}

variable "environment_name" {
  type        = string
  default     = "env"
  description = "An environment name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account"
}

variable "vault_url" {
  type        = string
  default     = ""
  description = "The Azure Vault URL"
}

variable "oidc_k8s_issuer_url" {
  type        = string
  default     = ""
  description = "The OIDC k8s issuer url.  If using the kubernetes-ops/azure creation it would be in the AKS output."
}

variable "azure_tenant_id" {
  type        = string
  default     = ""
  description = "The Azure tenant id. If using the kubernetes-ops/azure creation it would be in the AKS output."
}

variable "azurerm_key_vault_id" {
  type        = string
  default     = ""
  description = "(Required) Specifies the id of the Key Vault resource. Changing this forces a new resource to be created."
}

variable "certificate_permissions" {
  type        = list(string)
  default     = [
    "Get",
  ]
  description = "(Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update"
}

variable "key_permissions" {
  type        = list(string)
  default     = [
    "Get",
  ]
  description = "(Optional) List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy, and SetRotationPolicy."
}

variable "secret_permissions" {
  type        = list(string)
  default     = [
    "Get",
  ]
  description = "(Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set."
}

variable "storage_permissions" {
  type        = list(string)
  default     = [
    "Get",
  ]
  description = "(Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update."
}

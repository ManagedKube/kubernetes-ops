variable "vault_name" {
  type = string
  default = "vault1"
  description = "(Required) Name of this vault instance"
}

variable "azure_location" {
  type = string
  default = "eastus2"
  description = "(Required) The Azure location"
}

variable "resource_group_name" {
  type = string
  default = "kubernetes-ops-aks"
  description = "(Required) The Azure resource group name."
}

variable "tenant_id" {
  type = string
  default = ""
  description = "(Required) The Azure tentant ID."
}

variable "sku_name" {
  type = string
  default = "standard"
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
}

variable "public_network_access_enabled" {
  type = bool
  default = true
  description = "(Optional) Whether public network access is allowed for this Key Vault. Defaults to true."
}

variable "soft_delete_retention_days" {
  type = number
  default = 90
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
}

variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault?"
  default     = false
}

variable "name" {
  type        = string
  default     = "zone.name.com"
  description = "(Required) The name of the DNS Zone. Must be a valid domain name."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
}

variable "soa_record" {
  type        = list
  default     = null
  description = "(Optional) An soa_record block as defined below. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "enable_azurerm_private_dns_zone_virtual_network_link" {
  type        = bool
  default     = false
  description = "Enable the private DNS link to a vnet or not"
}

variable "vnet_name" {
  type        = string
  default     = null
  description = "(Required if enable_azurerm_private_dns_zone_virtual_network_link is true) The name of the vnet."
}

variable "vnet_resource_group" {
  type        = string
  default     = null
  description = "(Required if enable_azurerm_private_dns_zone_virtual_network_link) The name of the resource group the vnet belongs to."
}

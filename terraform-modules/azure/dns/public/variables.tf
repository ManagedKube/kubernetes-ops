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

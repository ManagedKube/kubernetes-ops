variable "subnet_name" {
  type        = string
  default     = ""
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created." 
}

variable "virtual_network_name" {
  type        = string
  default     = ""
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  type        = list
  default     = ["10.0.1.0/24"]
  description = "(Required) The address prefixes to use for the subnet."
}

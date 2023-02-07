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

variable "subnets" {
  description = "A list of subnets to create"
  type        = any
  default     = [
    {
      name             = "SNET-AKS-Private-1"
      address_prefixes = ["10.10.10.0/24"]
    },
  ]
}
variable "peer_1_name" {
  type        = string
  default     = "peer_1"
  description = "peer_1 name" 
}

variable "peer_1_resource_group" {
  type        = string
  default     = "peer_1_resource_group"
  description = "peer_1 resource group name" 
}

variable "peer_1_virtual_network_name" {
  type        = string
  default     = "peer_1_virtual_network_name"
  description = "peer_1 vnet name" 
}

variable "peer_2_name" {
  type        = string
  default     = "peer_2"
  description = "peer_2 name" 
}

variable "peer_2_resource_group" {
  type        = string
  default     = "peer_2_resource_group"
  description = "peer_2 resource group name" 
}

variable "peer_2_virtual_network_name" {
  type        = string
  default     = "peer_2_virtual_network_name"
  description = "peer_2 vnet name" 
}

variable "tags" {
  type        = any
  default     = {}
  description = "Tags to place on the resources" 
}

variable "peer_1_allow_forwarded_traffic" {
  type        = bool
  default     = false
  description = "(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false." 
}

variable "peer_2_allow_forwarded_traffic" {
  type        = bool
  default     = false
  description = "(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false." 
}

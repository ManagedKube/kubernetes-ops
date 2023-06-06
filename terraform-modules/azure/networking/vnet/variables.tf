variable "resource_group_name" {
  type        = string
  default     = ""
  description = "(Required) The name of the resource group in which to create the virtual network." 
}

variable "vnet_name" {
  type        = string
  default     = ""
  description = "(Required) The vnet's name" 
}

variable "security_rules" {
  type        = list(any)
  default     = [
    {
        name                       = "allow_all_inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    },
    {
        name                       = "allow_all_outbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  ]
  description = "(Required) List of objects representing security rules, as defined below." 
}

variable "tags" {
  type        = any
  default     = {}
  description = "Tags to place on the resources" 
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "The list of address spaces used by the virtual network." 
}

variable "dns_servers" {
  type        = list(string)
  default     = null # ["10.0.0.4", "10.0.0.5"]
  description = "(Optional) List of IP addresses of DNS servers.  Null will set it to Azure provided DNS" 
}

variable "subnets" {
  type        = list(any)
  default     = [
    {
        name           = "subnet1"
        address_prefix = "10.0.1.0/24"
    },
    {
        name           = "subnet2"
        address_prefix = "10.0.2.0/24"
    },
  ]
  description = "(Optional) Can be specified multiple times to define multiple subnets. Each subnet block supports fields documented below." 
}

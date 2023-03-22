variable "vpc_attachments" {
    description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
    type        = any
    default     = {}
}

variable "core_network_id" {
    description = "Core-Network Id that VPC need to attached"
    type = string
}

variable "appliance_mode_support" {
    description = "If enabled, traffic flow between a source and destination use the same Availability Zone for the VPC attachment for the lifetime of that flow"
    type = bool
    default = false
}

variable "ipv6_support" {
    description = "Indicates whether IPv6 is supported."
    type = bool
    default = false
}

variable "tags" {
    description = "Defaults tags for the resource"
    type =map(string)
    default = {}
  
}
variable "segment_nametag" {
    description = "Attachment tag for which segment the vpc need to attach"
    type = string
  
}

variable "route_cidr_blocks" {
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type        = list(string)
  default     = []
}

variable "private_route_table_id" {
  type = string
  default = ""
}

variable "public_route_table_id" {
  type = string
  default = ""
}

variable "core_network_arn" {
    type = string
    description = "Routes targeted to destination Core-network"
  
}

variable "create_public_route" {
  type = bool
  default = true
  
}

variable "create_private_route" {
  type = bool
  default = true
  
}

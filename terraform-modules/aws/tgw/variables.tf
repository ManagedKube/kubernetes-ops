  variable "create_tgw" {
    type = bool
    default = true
  }

  variable "name" {}
  variable "description" {
    type = string
    default = ""
  }
  variable "enable_auto_accept_shared_attachments" {
    type = bool
    default = true
  }

  variable "vpc_attachments" {
    type = map(any)
    default = {}
  }

  variable "ram_allow_external_principals" {
    type = bool
    default = true
  }
  variable "ram_principals" {
    type = list
    default = []
  } 

variable "tags" {
  type    = map(any)
  default = {}
}

variable "share_tgw" {
    type = bool
    default = false
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN."
  type        = string
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

variable "create_public_route" {
  type = bool
  default = true
  
}

variable "create_private_route" {
  type = bool
  default = true
  
}

variable "transit_gateway_id" {
  type = string
  default = ""
  
}
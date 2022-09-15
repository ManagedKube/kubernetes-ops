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

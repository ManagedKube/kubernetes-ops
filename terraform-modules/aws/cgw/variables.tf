  variable "create_cgw" {
    type = bool
    default = true
  }

  variable "cgw_name" {}
  variable "description" {
    type = string
    default = ""
  }

  variable "customer_gateways" {
    type = map(any)
  }

  variable "tags" {
    type    = map(any)
    default = {}
  }


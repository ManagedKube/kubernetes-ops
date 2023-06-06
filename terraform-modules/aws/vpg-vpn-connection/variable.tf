variable "vpc_id" {
    type = string
    description = "VPC Id to attach to the VPN gateway"
}

variable "amazon_side_asn" {
    type = string
    description = "ASN number for the VPN gateway"
}

variable "static_routes_only" {
    type = bool
    default = false
  
}

variable "customer_gateway_id" {
  type = list(string)
  default = []
}

variable "tags" {
    type = map(any)
    default = {}
  
}
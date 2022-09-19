variable "create_vpngw" {
    type = bool
    default = true
}

variable "connect_to_transit_gateway" {
    type = bool
    default = true
}

variable "transit_gateway_id" {}

variable "customer_gateway_id" {
    type = list(string)
}

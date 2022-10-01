variable "peer_account_id" {
    description = "defaults to requester account"
    type = string
    default = null
}

variable "peer_region" {
    type = list(string)
}

variable "peer_transit_gateway_id" {
    type = list(string)
}

variable "transit_gateway_id" {
    type = string
}

variable "tags" {
  description = "tags to apply to resource"
  type        = map(string)
  default     = {}
}

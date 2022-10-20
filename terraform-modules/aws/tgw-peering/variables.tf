variable "create_peer_tgw_connection" {
  description = "TGW peering connection"
  type = bool
  default = true
}

variable "peer_account_id" {
    description = "defaults to requester account"
    type = string
    default = null
}

variable "peer_region" {
    type = string
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

variable "create_tgw_static_route" {
  description = "Create tgw static route if TRUE"
  type        = bool
  default     = true
}

variable "destination_cidr_blocks" {
  description = "List of destination cidr blocks"
  type        = list(string)
  default     = []
}

variable "tgw_route_table_id" {
    description = "TGW default route table ID where the static routes need to be created"
    type        = string
    default     = null
}

variable "acceptor_region" {
  description = "TGW peering attachment acceptor region"
  type        = string
  default     = ""
  
}

variable "accept_tgw_peer_attachment" {
  description = "TGW peering accept"
  type = bool
  default = true
}

variable "acceptor_tags" {
  description = "tags to apply to resource"
  type        = map(string)
  default     = {}
}

variable "create_tgw_reverse_static_route" {
  description = "Create tgw reverse static route if TRUE"
  type        = bool
  default     = true
}

variable "destination_reverse_cidr_blocks" {
  description = "List of destination cidr blocks"
  type        = list(string)
  default     = []
}

variable "tgw_reverse_route_table_id" {
    description = "acceptor TGW default route table ID where the static routes need to be created"
    type        = string
    default     = null
}
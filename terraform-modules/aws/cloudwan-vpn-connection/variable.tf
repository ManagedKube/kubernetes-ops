variable "create_VPN_connection" {
  type = bool
  default = true
  description = "For creating VPN attachment to CloudWan"
}
variable "customer_gateway_id" {
  type = list(string)
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "static_routes_only" {
    type = bool
    default = false
    description = "To enable static routing make it true"
  
}

variable "core_network_id" {
  type =string
  description = "Core Network Id to be attached"
  
}

variable "segment_name" {
  type = string
  description = "To which segment the attachment need to be added"
  
}
variable "allowed_resolvers" {
  default     = []
  description = "List of allowed CIDRs. For inbound endpoints, this should be the list of CIDRs allowed to query. For outbound endpoints, this should be the list of DNS servers the endpoint will talk to."
  type        = list(string)
}

variable "direction" {
  description = "Specify inbound or outbound for type of resolver endpoint"
  type        = string
}

variable "ip_addresses" {
  description = "Specify subnets and IP addresses to use for your endpoints. subnet_id is mandatory, ip is optional"
  type        = list(map(any))

  # syntax:
  # object({
  #    subnet_id = string
  #    ip        = string
  #  }
}

variable "name" {
  description = "The friendly name of the Route 53 Resolver endpoint"
  type        = string
  default     = null
}

variable "tags" {
  default     = {}
  description = "Tags to apply to created resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID to place resolver endpoints in"
  type        = string
}

variable "dns_port" {
  default     = 53
  type        = number
  description = "Port used by DNS"
}
variable "create_vpc_peering_connection" {
  description = "Create VPC peering connection if set to true"
  type        = bool
  default     = true
}
variable "create_pcx_route" {
  description = "Create PCX route if set to true"
  type        = bool
  default     = true
}
variable "peer_acc_id" {
  description = "Remote peer account id"
  type        = string
  default     = ""
}

variable "peer_vpc_id" {
  description = "Remote peer vpc id"
  type        = string
  default     = ""
}

variable "owner_vpc_id" {
  description = "Owner vpc id"
  type        = string
  default     = ""
}

variable "auto_accept_peering" {
  description = "A boolean value to indicate auto-accept of peering"
  type        = bool
  default     = false
}

variable "tags" {
  description = "tags to apply to resource"
  type        = map(string)
  default     = {}
}

variable "instance_destination_cidr_blocks" {
  description = "List of destination cidr blocks for jump host"
  type        = list(string)
  default     = []
}

variable "pcx_destination_cidr_block" {
  description = "Destination cidr block for peering connection"
  type        = string
  default     = ""
}

variable "route_table_ids" {
  description = "Route table ID where the route will be created"
  type        = list(string)
  default     = []
}

variable "instance_id" {
  description = "Instance ID of the Jump host"
  type        = string
  default     = ""
}

variable "vpc_peering_connection_id" {
  description = "VPC Peering Connection ID for route"
  type        = string
  default     = ""
}

variable "network_interface_id" {
  description = "Network interface ID of host for route"
  type        = string
  default     = ""
}
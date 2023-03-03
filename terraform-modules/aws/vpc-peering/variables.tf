variable "vpc_id" {
  type = string
  description = "The ID of the VPC in which the subnets are located"
}

variable "peer_vpc_id" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection."
  type        = string
}

variable "auto_accept" {
  description = "Specifies whether the peering connection should be automatically accepted"
  type        = bool
  default     = true
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  description = "Specifies whether DNS resolution is enabled for the VPC peering connection"
  type        = bool
  default     = true
}

variable "requester_allow_remote_vpc_dns_resolution" {
  description = "Specifies whether DNS resolution is enabled for the VPC peering connection"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  type = list(string)
  description = "A list of subnet IDs for which to retrieve the associated route tables"
}

variable "tags" {
  description = "A map of tags to apply to the VPC peering connection"
  type        = map(any)
  default     = {}
}
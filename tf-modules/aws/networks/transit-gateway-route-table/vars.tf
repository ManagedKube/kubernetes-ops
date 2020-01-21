variable "aws_region" {}

variable "destination_cidr_block_list" {
  type = list(string)
  description = "Route list for the first AWS account.  A list of CIDRs."

  default = []
}

variable "blackhole_list" {
  type = list(string)
  description = "Route list for the first AWS account to black hole.  A list of CIDRs."

  default = []
}

variable "transit_gateway_attachment_id" {
  description = "The transit gateway for the routes"
  type = string
}

variable "transit_gateway_route_table_id" {
  description = "The transit gateway route table id"
  type = string
}

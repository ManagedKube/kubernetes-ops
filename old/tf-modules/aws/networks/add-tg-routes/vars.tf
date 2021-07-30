variable "aws_region" {}

variable "route_table_id_list" {
  type = list(string)
  description = "route table ID to add route to"
}

variable "transit-gateway-id" {
  description = "Transit gateway ID for the route"
}

variable "routes-list" {
  type = list(string)
  description = "Route list for the first AWS account.  A list of destination CIDRs to route to via the this transit gateway id."

  default = []
}

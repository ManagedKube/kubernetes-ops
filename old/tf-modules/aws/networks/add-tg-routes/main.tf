terraform {
    backend "s3" {
  }
}

provider "aws" {
    alias = "first"

    region     = "${var.aws_region}"
}

resource "aws_route" "route-first" {
    provider = "aws.first"
    count = length(var.route_table_id_list) * length(var.routes-list)

    route_table_id            = var.route_table_id_list[floor(count.index / length(var.routes-list))]
    destination_cidr_block    = var.routes-list[count.index % length(var.routes-list)]
    transit_gateway_id        = var.transit-gateway-id
}

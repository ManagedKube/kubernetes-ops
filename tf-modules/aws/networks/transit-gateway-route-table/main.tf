terraform {
    backend "s3" {
  }
}

provider "aws" {
    alias = "first"

    region     = "${var.aws_region}"
}

resource "aws_ec2_transit_gateway_route" "tg-route" {
    provider = aws.first
    count                          = length(var.destination_cidr_block_list)
    destination_cidr_block         = var.destination_cidr_block_list[count.index]
    blackhole                      = var.blackhole_list[count.index]
    transit_gateway_attachment_id  = var.transit_gateway_attachment_id
    transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

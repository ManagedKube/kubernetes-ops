resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  count = var.create_peer_tgw_connection ? 1 : 0
  peer_account_id         = var.peer_account_id
  peer_region             = var.peer_region
  #peer_region             = element(var.peer_region, count.index)
  peer_transit_gateway_id = element(var.peer_transit_gateway_id, count.index)
  transit_gateway_id      = var.transit_gateway_id

  tags = var.tags
}

resource "aws_ec2_transit_gateway_route" "tgw_route" {
  count                          = var.create_tgw_static_route ? length(var.destination_cidr_blocks) : 0
  destination_cidr_block         = element(var.destination_cidr_blocks, count.index)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.this[0].id
  transit_gateway_route_table_id = var.tgw_route_table_id
}

provider "aws" {
  alias = "acceptor"
  region = var.acceptor_region
}


resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this_acceptor" {
  count         = var.accept_tgw_peer_attachment ? 1 : 0
  provider = aws.acceptor
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.this[0].id
  tags = var.acceptor_tags
}

resource "aws_ec2_transit_gateway_route" "tgw_reverse_route" {
  count                          = var.create_tgw_reverse_static_route ? length(var.destination_reverse_cidr_blocks) : 0
  provider = aws.acceptor
  destination_cidr_block         = element(var.destination_reverse_cidr_blocks, count.index)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.this[0].id
  transit_gateway_route_table_id = var.tgw_reverse_route_table_id
}


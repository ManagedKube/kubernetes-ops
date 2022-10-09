resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  count = length(var.peer_transit_gateway_id)
  peer_account_id         = var.peer_account_id
  peer_region             = element(var.peer_region, count.index)
  peer_transit_gateway_id = element(var.peer_transit_gateway_id, count.index)
  transit_gateway_id      = var.transit_gateway_id

  tags = var.tags
}

resource "aws_ec2_transit_gateway_route" "tgw_route" {
  count                          = var.create_tgw_static_route ? length(var.destination_cidr_blocks) : 0
  destination_cidr_block         = element(var.destination_cidr_blocks, count.index)
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.this[count.index].id
  transit_gateway_route_table_id = var.tgw_route_table_id
}

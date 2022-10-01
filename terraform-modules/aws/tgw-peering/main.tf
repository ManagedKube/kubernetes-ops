resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  count = length(var.peer_transit_gateway_id)
  peer_account_id         = var.peer_account_id
  peer_region             = element(var.peer_region, count.index)
  peer_transit_gateway_id = element(var.peer_transit_gateway_id, count.index)
  transit_gateway_id      = var.transit_gateway_id

  tags = var.tags
}

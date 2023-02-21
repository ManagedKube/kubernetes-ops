
resource "aws_networkmanager_transit_gateway_peering" "tgw-peering" {
  count = length(var.transit_gateway_arn) 
  core_network_id     = var.core_network_id
  transit_gateway_arn = element(var.transit_gateway_arn, count.index)
  tags = var.tags
}

resource "aws_ec2_transit_gateway_policy_table_association" "policy_table_association" {
  count = length(var.transit_gateway_arn)
  transit_gateway_attachment_id   = resource.aws_networkmanager_transit_gateway_peering.tgw-peering[count.index].transit_gateway_peering_attachment_id
  transit_gateway_policy_table_id = element(var.tgw_policy_table_id, count.index)
  depends_on = [
    aws_networkmanager_transit_gateway_peering.tgw-peering
  ]
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "TGW-RT-attach" {
  count = length(var.route_table_arn)
  peering_id                      = "${resource.aws_networkmanager_transit_gateway_peering.tgw-peering[count.index].id}"
  transit_gateway_route_table_arn = element(var.route_table_arn, count.index)
  tags = merge(var.tags,{
     env = var.segment_name
  })
  depends_on = [
    aws_ec2_transit_gateway_policy_table_association.policy_table_association
  ]
}
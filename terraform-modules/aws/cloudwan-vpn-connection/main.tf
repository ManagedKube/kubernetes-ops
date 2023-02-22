resource "aws_vpn_connection" "main" {
  count = var.create_VPN_connection ? length(var.customer_gateway_id) : 0
  customer_gateway_id        = element(var.customer_gateway_id, count.index)
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only

  tags = var.tags
}


resource "aws_networkmanager_site_to_site_vpn_attachment" "test" {
  count = var.create_VPN_connection ? length(var.customer_gateway_id) : 0
  core_network_id    = var.core_network_id
  vpn_connection_arn = resource.aws_vpn_connection.main[count.index].arn
  tags = {
    segment = var.segment_name
  }
}
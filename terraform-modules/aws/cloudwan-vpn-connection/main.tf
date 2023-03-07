locals {
  customer_gateway_id = toset (var.customer_gateway_id)
  vpn_connection_arn = toset ([for my_arn in aws_vpn_connection.main: my_arn.arn])
}

resource "aws_vpn_connection" "main" {
  for_each = local.customer_gateway_id
  customer_gateway_id =each.key
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only
  tags = var.tags
}


resource "aws_networkmanager_site_to_site_vpn_attachment" "test" {
  for_each = local.vpn_connection_arn
  vpn_connection_arn = each.key
  core_network_id    = var.core_network_id
  tags = {
    env = var.segment_name
  }
}
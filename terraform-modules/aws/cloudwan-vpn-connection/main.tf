locals {
  customer_gateway_id = toset (var.customer_gateway_id)
  vpn_connection_arn = [for my_arn in aws_vpn_connection.main: my_arn.arn]
}

resource "aws_vpn_connection" "main" {
  for_each = local.customer_gateway_id
  customer_gateway_id =each.key
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only
  tags = var.tags
}


resource "aws_networkmanager_site_to_site_vpn_attachment" "test" {
  depends_on = [
    resource.aws_vpn_connection.main
  ]
  count = var.create_VPN_connection ? length(local.vpn_connection_arn) : 0
  vpn_connection_arn = local.vpn_connection_arn[count.index]
  core_network_id    = var.core_network_id
  tags = merge(var.tags, {
    env = var.segment_name
  })
}
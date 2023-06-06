locals {
  customer_gateway_id = toset (var.customer_gateway_id)
}

resource "aws_vpn_gateway" "vpn_gw" {
    amazon_side_asn = var.amazon_side_asn
    tags = var.tags
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
    depends_on = [
    resource.aws_vpn_gateway.vpn_gw
    ]
    vpc_id         = var.vpc_id
    vpn_gateway_id = resource.aws_vpn_gateway.vpn_gw.id
}

resource "aws_vpn_connection" "main" {
  for_each = local.customer_gateway_id
  customer_gateway_id =each.key
  vpn_gateway_id      = resource.aws_vpn_gateway.vpn_gw.id
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only
  tags = var.tags
}




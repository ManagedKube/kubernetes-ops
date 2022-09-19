module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.12.1"

  create_vpn_gateway_attachment = var.create_vpngw
  count = var.create_vpngw ? length(var.customer_gateway_id) : 0
  connect_to_transit_gateway    = var.connect_to_transit_gateway

  transit_gateway_id         = var.transit_gateway_id
  customer_gateway_id        = element(var.customer_gateway_id, count.index)
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "2.8.0"

  create_tgw  = var.create_tgw
  name        = var.name
  description = var.description

  enable_auto_accept_shared_attachments = var.enable_auto_accept_shared_attachments

  vpc_attachments = var.vpc_attachments

  ram_allow_external_principals = var.ram_allow_external_principals
  ram_principals = var.ram_principals
  amazon_side_asn = var.amazon_side_asn

  share_tgw = var.share_tgw
  tags = var.tags
}

resource "aws_route" "private_tgw" {
  count                  = var.create_private_route ? length(var.route_cidr_blocks) : 0
  route_table_id         = var.private_route_table_id
  destination_cidr_block = element(var.route_cidr_blocks, count.index)
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "public_tgw" {
  count                  = var.create_public_route ? length(var.route_cidr_blocks) : 0
  route_table_id         = var.public_route_table_id
  destination_cidr_block = element(var.route_cidr_blocks, count.index)
  transit_gateway_id     = var.transit_gateway_id
}
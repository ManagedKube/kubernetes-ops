resource "aws_networkmanager_vpc_attachment" "vpc_attachments" {
    for_each = var.vpc_attachments
    core_network_id        = var.core_network_id
    subnet_arns            = each.value.subnet_arns
    vpc_arn                = each.value.vpc_arn
    options{
    appliance_mode_support = try(var.appliance_mode_support, false)
    ipv6_support           = try(var.ipv6_support, false)
    }
    
    tags = merge (var.tags , {
        env = var.segment_nametag
    })
}

resource "aws_route" "private_route_table" {
  count                  = var.create_private_route ? length(var.route_cidr_blocks) : 0
  route_table_id         = var.private_route_table_id
  destination_cidr_block = element(var.route_cidr_blocks, count.index)
  core_network_arn       = var.core_network_arn
}

resource "aws_route" "public_route_table" {
  count                  = var.create_public_route ? length(var.route_cidr_blocks) : 0
  route_table_id         = var.public_route_table_id
  destination_cidr_block = element(var.route_cidr_blocks, count.index)
  core_network_arn       = var.core_network_arn
}
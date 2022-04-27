resource "aws_vpc_peering_connection" "this" {
  count         = var.create_vpc_peering_connection ? 1 : 0
  peer_owner_id = var.peer_acc_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.owner_vpc_id
  auto_accept   = var.auto_accept_peering

  tags = var.tags
}

resource "aws_route" "instance_route" {
  count                  = length(var.instance_destination_cidr_blocks)
  route_table_id         = var.route_table_ids[0]
  destination_cidr_block = element(var.instance_destination_cidr_blocks, count.index)
  # instance_id            = var.instance_id
  network_interface_id   = var.network_interface_id
}

resource "aws_route" "pcx_route" {
  count                     = var.create_pcx_route ? length(var.route_table_ids) : 0
  route_table_id            = element(var.route_table_ids, count.index)
  destination_cidr_block    = var.pcx_destination_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
}

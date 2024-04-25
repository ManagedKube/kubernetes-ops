# Create peering connection between VPC A and VPC B
resource "aws_vpc_peering_connection" "peering_connection" {
  vpc_id                 = var.vpc_id
  peer_vpc_id            = var.peer_vpc_id
  auto_accept            = var.auto_accept

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
  tags = var.tags
}

data "aws_route_table" "route_table" {
  for_each = { for id in var.subnet_ids : id => id }
  subnet_id = each.value
  vpc_id    = var.vpc_id
}

# Assign route table to corresponding subnets in VPC B
resource "aws_route_table_association" "association" {
  for_each = { for id in var.subnet_ids : id => id }
  subnet_id      = each.value
  route_table_id = data.aws_route_table.route_table[each.key].id
}

# Create endpoint access policy for VPC B
resource "aws_vpc_endpoint_route_table_association" "endpoint_association" {
  for_each = { for id in var.subnet_ids : id => id }
  vpc_endpoint_id = var.vpc_endpoint_id
  route_table_id  = data.aws_route_table.route_table[each.key].id
}


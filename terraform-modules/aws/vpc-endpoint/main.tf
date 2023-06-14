# Create a VPC endpoint for Execute API in the specified VPC
resource "aws_vpc_endpoint" "execute_api_endpoint" {
  vpc_id                = var.vpc_id
  service_name          = var.service_name
  vpc_endpoint_type     = var.vpc_endpoint_type
  security_group_ids    = [var.security_group_id]
  subnet_ids            = var.subnet_ids
  private_dns_enabled   = var.private_dns_enabled
  tags = var.tags
}

data "aws_network_interface" "execute_api_nics" {
  count = length(aws_vpc_endpoint.execute_api_endpoint.*.network_interface_ids)
  id    = aws_vpc_endpoint.execute_api_endpoint[count.index].network_interface_ids
}

#data "aws_network_interface" "execute_api_nics" {
#  for_each = toset(aws_vpc_endpoint.execute_api_endpoint.network_interface_ids)
#  id = each.key
#}
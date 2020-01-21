output "aws_route_table_id" {
  value = aws_route_table.route-table.id
}

output "aws_ec2_transit_gateway_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.transit-gateway.id
}

output "aws_ec2_transit_gateway_vpc_attachment_vpc_owner_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.transit-gateway.vpc_owner_id
}

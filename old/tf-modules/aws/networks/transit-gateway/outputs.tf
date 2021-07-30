output "aws_ec2_transit_gateway_arn" {
  value = aws_ec2_transit_gateway.transit-gateway.arn
}

output "aws_ec2_transit_gateway_id" {
  value = aws_ec2_transit_gateway.transit-gateway.id
}

output "aws_ec2_transit_gateway_association_default_route_table_id" {
  value = aws_ec2_transit_gateway.transit-gateway.association_default_route_table_id
}

output "aws_ec2_transit_gateway_propagation_default_route_table_id" {
  value = aws_ec2_transit_gateway.transit-gateway.propagation_default_route_table_id
}

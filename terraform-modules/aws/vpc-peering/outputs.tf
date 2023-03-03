output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peering_connection.id
}

output "vpc_peering_connection_accept_status" {
  description = "The status of the VPC Peering Connection request"
  value       = aws_vpc_peering_connection.peering_connection.accept_status
}

output "aws_route_table_association_id" {
  description = "The ID of the association"
  value       = aws_route_table_association.association.id
}

output "aws_vpc_endpoint_route_table_association_id" {
  description = "A hash of the EC2 Route Table and VPC Endpoint identifiers."
  value       = aws_vpc_endpoint_route_table_association.endpoint_association.id
}
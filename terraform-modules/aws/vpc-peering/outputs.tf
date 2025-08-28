output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.peering_connection.id
}

output "vpc_peering_connection_accept_status" {
  description = "The status of the VPC Peering Connection request"
  value       = aws_vpc_peering_connection.peering_connection.accept_status
}

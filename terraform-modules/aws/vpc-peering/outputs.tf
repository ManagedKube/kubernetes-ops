output "id" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_vpc_peering_connection.this.*.id
}

output "vpc_peering_accept_status" {
  description = "The status of the VPC Peering Connection request"
  value       = aws_vpc_peering_connection.this.*.accept_status
}


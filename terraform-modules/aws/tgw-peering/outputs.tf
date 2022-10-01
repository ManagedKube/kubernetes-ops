output "ids" {
  description = "The ID of the VPC Peering Connection"
  value       = aws_ec2_transit_gateway_peering_attachment.this[*].id
}
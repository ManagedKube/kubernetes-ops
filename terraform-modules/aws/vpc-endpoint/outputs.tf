output "dns_entry" {
  value = aws_vpc_endpoint.this[0].dns_entry
  description = "Represents the fully qualified domain name (FQDN) of the VPC endpoint."
}

output "dns_name" {
  value = aws_vpc_endpoint.this[0].dns_name
  description = "Represents the DNS name for the VPC endpoint service."
}
output "vpc_endpoint_id" {
  value       = module.record.name
  description = "The name for the Route 53 record."
}

output "fqdn" {
  value       = module.record.fqdn
  description = "FQDN built using the zone domain and name."
}

output "vpc_endpoint_id" {
  value = data.aws_vpc_endpoint.this.id
  description = "ID of an AWS VPC Endpoint"
}

output "vpc_endpoint_dns_entry" {
  value = data.aws_vpc_endpoint.this.dns_entry
  description = "Retrieve the DNS name associated with an AWS VPC Endpoint."
}

output "vpc_endpoint_dns_name" {
  value = data.aws_vpc_endpoint.this.dns_name
  description = "Retrieves the primary DNS name associated with the VPC Endpoint"
}
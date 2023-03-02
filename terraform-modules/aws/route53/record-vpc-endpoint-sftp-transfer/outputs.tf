output "name" {
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

output "vpc_endpoint_dns_name" {
  value = data.aws_vpc_endpoint.this.dns_entry.dns_name
  description = "Retrieve the DNS name associated with an AWS VPC Endpoint."
}

output "vpc_endpoint_hosted_zone_id" {
  value = data.aws_vpc_endpoint.this.dns_entry.hosted_zone_id
  description = "Retrieves the Zona ID name associated with the VPC Endpoint"
}
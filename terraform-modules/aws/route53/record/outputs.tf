output "name" {
  value       = aws_route53_record.this.name
  description = "The name for the Route 53 record."
}

output "fqdn" {
  value       = aws_route53_record.this.fqdn
  description = "FQDN built using the zone domain and name."
}

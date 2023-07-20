output "zone_ids" {
  value = aws_route53_zone_association.this[*].zone_id
}
output "vpc_associations" {
  value = aws_route53_zone_association.this[*].id
}

output "associated_vpc_ids" {
  value = keys(aws_route53_zone_association.this)
}
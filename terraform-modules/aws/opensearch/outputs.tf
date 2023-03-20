output "opensearch_domain_endpoint" {
  value = aws_opensearch_domain.this.endpoint
}

output "opensearch_security_group_id" {
  value = aws_security_group.opensearch_sg.id
}
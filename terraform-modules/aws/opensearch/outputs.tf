output "opensearch_domain_endpoint" {
  value = aws_opensearch_domain.this.endpoint
}

output "opensearch_security_group_id" {
  value = aws_security_group.opensearch_sg.id
}

output "aws_cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.opensearch_slow_logs.arn
}
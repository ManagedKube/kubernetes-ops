output "vpc_flow_id" {
  description = "The Flow Log ID"
  value       = aws_flow_log.this.id
}

output "vpc_flow_arn" {
  description = "The Flow Log ID"
  value       = aws_flow_log.this.arn
}
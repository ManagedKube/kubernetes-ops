output "arn" {
  description = "ARN"
  value       = aws_prometheus_workspace.this.arn
}

output "id" {
  description = "Identifier of the workspace"
  value       = aws_prometheus_workspace.this.id
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace."
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

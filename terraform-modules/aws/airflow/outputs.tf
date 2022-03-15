output "arn" {
  value       = aws_mwaa_environment.this.arn
}

output "webserver_url" {
  value       = aws_mwaa_environment.this.webserver_url
}

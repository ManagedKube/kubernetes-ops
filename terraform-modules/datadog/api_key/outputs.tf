output "api_key" {
  value       = datadog_api_key.this.
  sensitive   = true
  description = "The Datadog API key"
}

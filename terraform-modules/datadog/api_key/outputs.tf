output "api_key" {
  value       = datadog_api_key.this.key
  sensitive   = true
  description = "The Datadog API key"
}

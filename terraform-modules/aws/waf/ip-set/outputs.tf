# Define outputs for the IP set

output "id" {
  value       = aws_wafv2_ip_set.example.id
  description = "A unique identifier for the IP set."
}

output "arn" {
  value       = aws_wafv2_ip_set.example.arn
  description = "The Amazon Resource Name (ARN) of the IP set."
}

output "tags_all" {
  value       = aws_wafv2_ip_set.example.tags_all
  description = "A map of tags assigned to the IP set, including those inherited from the provider default_tags configuration block."
}

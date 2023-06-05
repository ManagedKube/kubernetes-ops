output "amplify_app_id" {
  description = "The ID of the created Amplify App"
  value       = aws_amplify_app.amplify.id
}

output "amplify_app_arn" {
  description = "The ARN of the created Amplify App"
  value       = aws_amplify_app.amplify.arn
}

output "amplify_app_name" {
  description = "The name of the created Amplify App"
  value       = aws_amplify_app.amplify.name
}

output "amplify_app_default_domain" {
  description = "The default domain of the created Amplify App"
  value       = aws_amplify_app.amplify.default_domain
}
output "arn" {
  description = "ARN of the user pool."
  value       = aws_cognito_user_pool.pool.arn
}

output "creation_date" {
  description = "Date the user pool was created."
  value       = aws_cognito_user_pool.pool.creation_date
}

output "custom_domain" {
  description = "A custom domain name that you provide to Amazon Cognito."
  value       = aws_cognito_user_pool.pool.custom_domain
}

output "domain" {
  description = "Holds the domain prefix if the user pool has a domain associated with it."
  value       = aws_cognito_user_pool.pool.domain
}

output "endpoint" {
  description = "Endpoint name of the user pool."
  value       = aws_cognito_user_pool.pool.endpoint
}

output "estimated_number_of_users" {
  description = "A number estimating the size of the user pool."
  value       = aws_cognito_user_pool.pool.estimated_number_of_users
}

output "id" {
  description = "ID of the user pool."
  value       = aws_cognito_user_pool.pool.id
}

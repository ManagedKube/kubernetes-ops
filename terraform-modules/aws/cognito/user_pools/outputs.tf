output "arn" {
  value = aws_cognito_user_pool.pool.arn
}

output "domain" {
  value = aws_cognito_user_pool.pool.domain
}

output "endpoint" {
  value = aws_cognito_user_pool.pool.endpoint
}

output "cognito_domain" {
  value = "https://${var.name}.auth.${data.aws_region.current}.amazoncognito.com"
}

output "arn" {
  value = aws_cognito_user_pool.pool.arn
}

output "domain" {
  value = aws_cognito_user_pool.pool.domain
}

output "endpoint" {
  value = aws_cognito_user_pool.pool.endpoint
}

## Section: Get the IdP metadata for your Okta application
output "cognito_domain" {
  value = "https://${var.name}.auth.${data.aws_region.current.name}.amazoncognito.com"
}

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

## Section: Construct the endpoint URL
output "login_endpoint" {
  value = "https://${var.name}.auth.${data.aws_region.current.name}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.main.id}&redirect_uri=${var.aws_cognito_user_pool_client_callback_urls[0]}"
}

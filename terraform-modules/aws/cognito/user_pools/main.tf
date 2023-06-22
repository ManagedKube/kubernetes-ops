resource "aws_cognito_user_pool" "pool" {
  name = var.name

  tags = var.tags
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.name
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool" "pool" {
  name = var.name

  tags = var.tags
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.name
  user_pool_id = aws_cognito_user_pool.pool.id
}

data "aws_region" "current" {}

resource "aws_cognito_identity_provider" "main" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = var.provider_name
  provider_type = "SAML"

  provider_details = {
    MetadataURL = var.metadata_url
  }
}

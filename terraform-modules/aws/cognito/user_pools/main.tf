## This basically follows the ClickOps instructions here: https://repost.aws/knowledge-center/cognito-okta-saml-identity-provider
## and automates the AWS cognito user pool creation and configuration.

resource "aws_cognito_user_pool" "pool" {
  name = var.name

  tags = var.tags
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.name
  user_pool_id = aws_cognito_user_pool.pool.id
}

data "aws_region" "current" {}

## Section: Configure Okta as a SAML IdP in your user pool
resource "aws_cognito_identity_provider" "main" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = var.provider_name
  provider_type = "SAML"

  provider_details = {
    MetadataURL = var.metadata_url
  }

  ## Section: Map email address from IdP attribute to user pool attribute
  attribute_mapping = {
    email    = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
  }
}

## Section: Change app client settings for your user pool
resource "aws_cognito_user_pool_client" "main" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  callback_urls                        = var.aws_cognito_user_pool_client_callback_urls
  logout_urls                          = var.aws_cognito_user_pool_client_logout_urls
  allowed_oauth_flows_user_pool_client = var.aws_cognito_user_pool_client_allowed_oauth_flows_user_pool_client
  allowed_oauth_flows                  = var.aws_cognito_user_pool_client_allowed_oauth_flows
  allowed_oauth_scopes                 = var.aws_cognito_user_pool_client_allowed_oauth_scopes
  supported_identity_providers         = var.aws_cognito_user_pool_client_supported_identity_providers
}

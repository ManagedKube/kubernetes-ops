variable "tags" {
  default = {}
}

variable "name" {
  description = "The name of the user pool.  This should be unique across your AWS account.  Putting in an env name in here is recommended."
}

variable "provider_name" {
  default = "Okta"
}

variable "metadata_url" {
  description = "The URL of the SAML metadata file provided by the SAML IdP."
}

variable "aws_cognito_user_pool_client_callback_urls" {
  description = "A URL where you want your users to be redirected after they log in"
  default     = ["https://example.com"]
}

variable "aws_cognito_user_pool_client_logout_urls" {
  description = "A URL where you want your users to be redirected after they log out"
  default     = ["https://example.com"] 
}

variable "aws_cognito_user_pool_client_supported_identity_providers" {
  description = "Identity provider list for server-side authentication flow."
  default     = ["COGNITO", "OKTA"]
}

variable "aws_cognito_user_pool_client_allowed_oauth_flows_user_pool_client" {
  description = "Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools"
  default     = true
}

variable "aws_cognito_user_pool_client_allowed_oauth_flows" {
  description = "Allowed OAuth flows for the client"
  default     = ["code", "implicit"]
}
  
variable "aws_cognito_user_pool_client_allowed_oauth_scopes" {
  description = "Allowed OAuth scopes for the client"
  default     = ["email", "openid"]
}

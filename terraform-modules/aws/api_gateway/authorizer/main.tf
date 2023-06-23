resource "aws_api_gateway_authorizer" "main" {
  name                   = var.name
  rest_api_id            = var.rest_api_id
  authorizer_uri         = var.authorizer_uri
  authorizer_credentials = var.authorizer_credentials
  type                   = var.type
  provider_arns          = var.provider_arns
  identity_source        = var.identity_source
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = var.vpc_link_name
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

resource "aws_apigatewayv2_api" "proxy_api" {
  name          = var.api_name
  protocol_type = var.api_protocol_type

  cors_configuration {
    allow_methods = var.allow_methods
    allow_headers = var.allow_headers
    allow_origins = var.allow_origins
  }

  vpc_link_id = aws_apigatewayv2_vpc_link.vpc_link.id
}

resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.proxy_api.id
  route_key = var.route_key

  authorization_type = var.route_authorization_type
  target             = "integrations/${aws_apigatewayv2_integration.proxy_integration.id}"
}

resource "aws_apigatewayv2_integration" "proxy_integration" {
  api_id           = aws_apigatewayv2_api.proxy_api.id
  integration_type = var.integration_type
  integration_uri  = var.integration_uri

  connection_type = var.connection_type
  connection_id   = aws_apigatewayv2_vpc_link.vpc_link.id
}

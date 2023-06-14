resource "aws_api_gateway_rest_api" "my_api" {
  name                   = var.apigateway_name
  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = ["${var.vpc_endpoint_id}"]  # Replace with your VPC endpoint ID
  }
}

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "vpc_proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  type = "VPC_PROXY"
  vpc_link_id = var.vpc_link_id
  endpoint_url = var.api_gateway_b_uri
  integration_http_method = "ANY"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_parameters = {}
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.proxy_resource.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "200"
  response_templates = {
    "application/json" = ""
  }
}

#resource "aws_api_gateway_integration" "proxy_integration" {
#  rest_api_id          = aws_api_gateway_rest_api.my_api.id
#  resource_id          = aws_api_gateway_resource.proxy_resource.id
#  http_method          = aws_api_gateway_method.proxy_method.http_method
#  type                 = "VPC_PROXY"
#  uri                  = var.api_gateway_b_uri
#  integration_http_method = "ANY"

#  cache_key_parameters = ["method.request.path.proxy"]
#  request_parameters = {
#    "integration.request.path.proxy" = "method.request.path.proxy"
#  }
#}

#resource "aws_api_gateway_integration_response" "proxy_integration_response" {
#  rest_api_id     = aws_api_gateway_rest_api.my_api.id
#  resource_id     = aws_api_gateway_resource.proxy_resource.id
#  http_method     = aws_api_gateway_method.proxy_method.http_method
#  status_code     = aws_api_gateway_method_response.proxy_method_response.status_code
#}

#resource "aws_api_gateway_method_response" "proxy_method_response" {
#  rest_api_id = aws_api_gateway_rest_api.my_api.id
#  resource_id = aws_api_gateway_resource.proxy_resource.id
#  http_method = aws_api_gateway_method.proxy_method.http_method
#  status_code = "200"
#}


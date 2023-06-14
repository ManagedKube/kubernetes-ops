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
  connection_type = "VPC_LINK"
  connection_id = var.vpc_link_id
  uri = var.api_gateway_b_uri
  integration_http_method = "ANY"
  passthrough_behavior = "WHEN_NO_MATCH"
  type = "HTTP_PROXY"
}



#CORS
resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.my_api.id}"
    resource_id   = "${aws_api_gateway_resource.proxy_resource.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
    rest_api_id   = "${aws_api_gateway_rest_api.my_api.id}"
    resource_id   = "${aws_api_gateway_resource.proxy_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "200"
    
    response_models = {
        "application/json" = "Empty"
    }

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = ["aws_api_gateway_method.options_method"]
}

resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.my_api.id}"
    resource_id   = "${aws_api_gateway_resource.proxy_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    type          = "MOCK"
    depends_on = ["aws_api_gateway_method.options_method"]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
    rest_api_id   = "${aws_api_gateway_rest_api.my_api.id}"
    resource_id   = "${aws_api_gateway_resource.proxy_resource.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    status_code   = "${aws_api_gateway_method_response.options_200.status_code}"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = ["aws_api_gateway_method_response.options_200"]
}

#resource "aws_api_gateway_method_response" "proxy" {
#  rest_api_id = aws_api_gateway_rest_api.my_api.id
#  resource_id = aws_api_gateway_resource.proxy_resource.id
#  http_method = aws_api_gateway_method.proxy_method.http_method
#}

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


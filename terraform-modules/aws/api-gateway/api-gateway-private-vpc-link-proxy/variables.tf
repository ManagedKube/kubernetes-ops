variable "apigateway_name" {
  description = "Api Gateway Name"
}

variable "vpc_endpoint_id" {
  description = "VPC Endpoint Id to hit the api gateway in private mode"
}

variable "vpc_link_id" {
  description = "VPC Link Id to hit the api gateway in private mode"
}

variable "api_gateway_b_uri" {
  description = "Api gateway URI of another account to connect and make a proxy"
}

variable "policy" {
  description = "Api gateway URI of another account to connect and make a proxy"
}
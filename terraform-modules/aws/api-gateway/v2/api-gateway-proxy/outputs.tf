output "vpc_link_id" {
  value       = aws_apigatewayv2_vpc_link.vpc_link.id
  description = "The ID of the VPC Link."
}

output "proxy_api_id" {
  value       = aws_apigatewayv2_api.proxy_api.id
  description = "The ID of the API."
}

output "proxy_integration_id" {
  value       = aws_apigatewayv2_integration.proxy_integration.id
  description = "The ID of the API integration."
}

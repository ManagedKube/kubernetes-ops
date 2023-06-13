## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.proxy_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_integration.proxy_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.proxy_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_vpc_link.vpc_link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_headers"></a> [allow\_headers](#input\_allow\_headers) | The list of allowed headers for CORS configuration. | `list(string)` | <pre>[<br>  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"<br>]</pre> | no |
| <a name="input_allow_methods"></a> [allow\_methods](#input\_allow\_methods) | The list of allowed methods for CORS configuration. | `list(string)` | <pre>[<br>  "ANY"<br>]</pre> | no |
| <a name="input_allow_origins"></a> [allow\_origins](#input\_allow\_origins) | The list of allowed origins for CORS configuration. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | The name of the API. | `string` | `"MyProxyApi"` | no |
| <a name="input_api_protocol_type"></a> [api\_protocol\_type](#input\_api\_protocol\_type) | The protocol type for the API. | `string` | `"HTTP"` | no |
| <a name="input_connection_type"></a> [connection\_type](#input\_connection\_type) | The connection type for the integration. | `string` | `"VPC_LINK"` | no |
| <a name="input_integration_type"></a> [integration\_type](#input\_integration\_type) | The integration type for the API integration. | `string` | `"HTTP_PROXY"` | no |
| <a name="input_integration_uri"></a> [integration\_uri](#input\_integration\_uri) | The URI for the integration. | `string` | `"https://api.another-gateway.com/{proxy}"` | no |
| <a name="input_route_authorization_type"></a> [route\_authorization\_type](#input\_route\_authorization\_type) | The authorization type for the route. | `string` | `"NONE"` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | The route key for the API route. | `string` | `"ANY /{proxy+}"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The list of security group IDs associated with the VPC Link. | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnet IDs where the VPC Link will be created. | `list(string)` | n/a | yes |
| <a name="input_vpc_link_name"></a> [vpc\_link\_name](#input\_vpc\_link\_name) | The name of the VPC Link resource. | `string` | `"MyVpcLink"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_proxy_api_id"></a> [proxy\_api\_id](#output\_proxy\_api\_id) | The ID of the API. |
| <a name="output_proxy_integration_id"></a> [proxy\_integration\_id](#output\_proxy\_integration\_id) | The ID of the API integration. |
| <a name="output_vpc_link_id"></a> [vpc\_link\_id](#output\_vpc\_link\_id) | The ID of the VPC Link. |

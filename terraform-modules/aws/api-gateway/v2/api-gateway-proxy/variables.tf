variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs where the VPC Link will be created."
}

variable "security_group_ids" {
  type        = list(string)
  description = "The list of security group IDs associated with the VPC Link."
}

variable "vpc_link_name" {
  type        = string
  default     = "MyVpcLink"
  description = "The name of the VPC Link resource."
}

variable "api_name" {
  type        = string
  default     = "MyProxyApi"
  description = "The name of the API."
}

variable "allow_methods" {
  type        = list(string)
  default     = ["ANY"]
  description = "The list of allowed methods for CORS configuration."
}

variable "allow_headers" {
  type        = list(string)
  default     = ["'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"]
  description = "The list of allowed headers for CORS configuration."
}

variable "allow_origins" {
  type        = list(string)
  default     = ["*"]
  description = "The list of allowed origins for CORS configuration."
}

variable "route_key" {
  type        = string
  default     = "ANY /{proxy+}"
  description = "The route key for the API route."
}

variable "integration_uri" {
  type        = string
  default     = "https://api.another-gateway.com/{proxy}"
  description = "The URI for the integration."
}

variable "api_protocol_type" {
  type        = string
  default     = "HTTP"
  description = "The protocol type for the API."
}

variable "route_authorization_type" {
  type        = string
  default     = "NONE"
  description = "The authorization type for the route."
}

variable "integration_type" {
  type        = string
  default     = "HTTP_PROXY"
  description = "The integration type for the API integration."
}

variable "connection_type" {
  type        = string
  default     = "VPC_LINK"
  description = "The connection type for the integration."
}

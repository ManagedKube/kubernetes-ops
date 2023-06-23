variable "name" {
  
}

variable "rest_api_id" {
  description = "The API Gateway ID."
}

variable "authorizer_uri" {
  description = "(Optional) The authorizer URI."
  default     = null
}

variable "authorizer_credentials" {
  description = "(Optional) The authorizer credentials."
  default     = null
}

variable "type" {
  description = "(Optional) Type of the authorizer. Possible values are TOKEN for a Lambda function using a single authorization token submitted in a custom header, REQUEST for a Lambda function using incoming request parameters, or COGNITO_USER_POOLS for using an Amazon Cognito user pool. Defaults to TOKEN."
  default     = "COGNITO_USER_POOLS"
}

variable "provider_arns" {
  description = "(Optional, required for type COGNITO_USER_POOLS) List of the Amazon Cognito user pool ARNs. Each element is of this format: arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}."
  default     = []
}

variable "identity_source" {
  description = "(Optional) Source of the identity in an incoming request. Defaults to method.request.header.Authorization. For REQUEST type, this may be a comma-separated list of values, including headers, query string parameters and stage variables - e.g., \"method.request.header.SomeHeaderName,method.request.querystring.SomeQueryStringName,stageVariables.SomeStageVariableName\""
  default     = "method.request.header.Authorization"
}

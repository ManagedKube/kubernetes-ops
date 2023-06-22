variable "tags" {
  default = {}
}

variable "name" {
  description = "The name of the user pool.  This should be unique across your AWS account.  Putting in an env name in here is recommended."
}

variable "client_id" {
  description = "The client id of the Okta app."
}
  
variable "client_secret" {
  description = "The client secret of the Okta app."
}

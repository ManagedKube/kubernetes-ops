variable "tags" {
  default = {}
}

variable "name" {
  description = "The name of the user pool.  This should be unique across your AWS account.  Putting in an env name in here is recommended."
}
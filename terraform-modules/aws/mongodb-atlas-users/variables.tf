variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "create_aws_secret" {
  type        = bool
  description = "To create an AWS secret or not"
  default     = false
}

variable "aws_secret_name" {
  type        = string
  description = "The name for the AWS secret"
}

variable "aws_secret_description" {
  type        = string
  description = "The aws secret description"
  default     = ""
}

variable "recovery_window_in_days" {
  type        = number
  description = "(Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30."
  default     = 0
}

variable "iam_role_name" {
  type        = string
  description = "The IAM Role name to assign an auth user to the DB"
}

variable "user_password" {
  type        = string
  description = "The password for the user"
  default     = null
}

variable "tags" {
  description = "A list of Tags"
  type        = map(any)
}

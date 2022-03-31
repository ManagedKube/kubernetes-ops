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
  default     = null
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

variable "user_password" {
  type        = string
  description = "The password for the user"
  default     = null
}

variable "tags" {
  description = "A list of Tags"
  type        = map(any)
}

variable "database_username" {
  description = "The username to create"
  type        = string
  default     = "admin"
}

variable "roles" {
  type        = list[map]
  default     = [
    {
      role_name = "readWrite"
      database_name = "my_db"
    },
  ]
  description = "The set of roles that are applied to the user"
}

variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "tags" {
  description = "A list of Tags"
  type        = map(any)
}

variable "roles" {
  type        = list(any)
  default     = [
    {
      role_name = "readWrite"
      database_name = "my_db"
    },
  ]
  description = "The set of roles that are applied to the user"
}

variable "enable_aws_secret" {
  type        = bool
  default     = false
  description = "A flag to denote that we will put the password secret into aws secret"
}

variable "enable_percent_encoding_password" {
  type        = bool
  default     = false
  description = "A flag to denote that we will put the password secret into aws secret in percent encoding according mongodb documentation: https://www.mongodb.com/docs/manual/reference/connection-string/#examples"
}

variable "database_users" {
  # type        = map(object({
  #   cidr_block = string
  # }))
  type = any
  description = "description"
  default     = [
    {
      username = "foo"
      aws_secret_name   = "my_secret"
      aws_secret_description = "my secret description"
      # (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30.
      recovery_window_in_days = 0
      # Only needed if enable_aws_secret==false, then all user needs to have
      # this password filled out.
      user_password = null
      auth_database_name = "admin"
      roles = [
        {
          role_name = "readWrite"
          database_name = "my_db"
        },
      ]
      tags = {}
    },
  ]
}

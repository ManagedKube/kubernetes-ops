variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
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
  type        = list(any)
  default     = [
    {
      role_name = "readWrite"
      database_name = "my_db"
    },
  ]
  description = "The set of roles that are applied to the user"
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
      # Setting create_aws_secret to true should be done as all or none to the users in this list
      # autogenerate a password and put it into AWS Secrets
      create_aws_secret = false
      aws_secret_name   = "my_secret"
      aws_secret_description = "my secret description"
      # (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30.
      recovery_window_in_days = 0
      # Only needed if create_aws_secret==false, then all user needs to have
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

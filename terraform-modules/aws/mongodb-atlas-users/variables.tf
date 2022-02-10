variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster as it appears in Atlas."
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

variable "create_custom_user" {
  type        = bool
  description = "To create a custom user or not"
  default     = false
}

variable "custom_user_iam_role" {
  type        = string
  description = "The AWS IAM Role of the custom user"
  default     = null
}

variable "custom_user_roles" {
  type        = list(any)
  description = "A list mapping roles to databases for the custom user"
  default = [
    {
      role_name     = "readWriteAnyDatabase"
      database_name = "admin"
    }
  ]
}

variable "custom_user_labels" {
  type        = list(any)
  description = "A list of key-value pairs for tagging the custom user"
  default = [
    {
      key   = "%s"
      value = "%s"
    }
  ]
}

variable "custom_user_scopes" {
  type        = list(any)
  description = "A list of clusters and data lakes the custom user"
  default = [
    {
      name = "my_cluster"
      type = "CLUSTER"
    }
  ]
}

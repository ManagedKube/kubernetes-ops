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

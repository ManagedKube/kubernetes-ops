variable "log_group_name" {
  type        = string
  default     = "log-group-default"
  description = "Log group name of cloud watch"
}

variable "kms_deletion_window_in_days" {
  type        = number
  default     = 30
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
}

variable "kms_enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled. Defaults to false."
}


variable "tags" {
  type = map(any)
}
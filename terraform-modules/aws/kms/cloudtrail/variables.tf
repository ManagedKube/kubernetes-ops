variable "cloudtrail_name" {
  type        = string
  default     = "cloudtrail-default"
  description = "Cloudtrail/trail for attaching currently kms"
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
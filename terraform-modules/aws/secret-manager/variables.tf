# Controls whether to create a KMS key or not.
variable "create_kms_key" {
  description = "A boolean flag to indicate whether to create a KMS key or not"
  type        = bool
  default     = false
}

variable "secretsmanager_kms_name" {
  description = "The display name of the KMS key"
  type        = string
  default     = ""
}

variable "secretsmanager_kms_name_alias" {
  description = "The Alias name of the KMS key"
  type        = string
  default     = ""
}

variable "secretsmanager_kms_deletion_window_in_days" {
  description = "The number of days to wait before deleting the KMS key"
  type        = number
  default     = 30
}

variable "secretsmanager_secret_name" {
  description = "The name of the Secrets Manager secret"
  type        = string
}

variable "secretsmanager_secret_description" {
  description = "The description of the Secrets Manager secret"
  type        = string
  default     = ""
}

variable "secretsmanager_secret_recovery_window_in_days" {
  description = "The number of days to wait before deleting the Secrets Manager secret"
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  type        = string
  default     = ""
  description = "The instance name"
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "The S3 bucket to point Athena to"
}

variable encryption_option {
  type        = string
  default     = "SSE_S3"
  description = "Encryption option"
}

variable "kms_key" {
  type        = string
  default     = null
  description = "The kms key"
}

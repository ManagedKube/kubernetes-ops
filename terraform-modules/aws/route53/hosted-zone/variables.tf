variable "domain_name" {
    description = "The domain name"
    type = string
}

variable "kms_alias" {
  description = "kms alias"
  type        = string
  default     = "key"
}
variable "tags" {
    type = map(any)
}

variable "kms_key_policy" {
    description = "JSON policy for kms key"
    type        = string
    default     = ""
}

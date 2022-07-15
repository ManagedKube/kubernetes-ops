variable "cloudtrail_name" {
  type        = string
  default     = "cloudtrail-default"
  description = "Cloudtrail/trail for attaching currently kms"
}

variable "tags" {
  type = map(any)
}
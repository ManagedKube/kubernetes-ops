variable "create_zones" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
}

variable "create_records" {
  description = "Whether to create DNS records"
  type        = bool
  default     = false
}

variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "records" {
  description = "List of maps of DNS records"
  type        = any
  default     = []
}

variable "private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}

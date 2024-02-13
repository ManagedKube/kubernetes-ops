# Define variables for the IP set

variable "ip_set_name" {
  type        = string
  description = "The name of the IP set."
}

variable "ip_set_description" {
  type        = string
  description = "A description of the IP set."
}

variable "ip_addresses" {
  type        = list(string)
  description = "A list of IP addresses in CIDR notation to include in the IP set."
}

variable "scope" {
  type        = string
  description = "(Required) Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the Region US East (N. Virginia)."
  default     = "REGIONAL"
}

variable "ip_address_version" {
  type        = string
  description = "(Required) Specify IPV4 or IPV6. Valid values are IPV4 or IPV6."
  default     = "IPV4"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the IP set."
}

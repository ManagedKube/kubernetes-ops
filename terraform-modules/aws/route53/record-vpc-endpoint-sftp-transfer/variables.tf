variable "route53_zone_id" {
  description = "The ID of the Route 53 zone where the record will be created."
  type        = string
}

variable "record_name" {
  description = "The name for the Route 53 record."
  type        = string
}

variable "type" {
  type        = string
  default     = "A"
  description = "Also known as an Address record, is used to map a domain name to an IP address."
}

variable "evaluate_target_health" {
  type        = bool
  default     = false
  description = "whether or not Route 53 should perform health checks on the target of an alias record before responding to DNS queries."
}

variable "transfer_server_id" {
  type        = string
  default     = ""
  description = "The ID of the AWS Transfer Server"
}

variable vpc_id {
  type        = string
  default     = ""
  description = "The VPC ID Where VPC enpoint is configured"
}


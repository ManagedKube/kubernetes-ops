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


variable "vpc_endpoint_dns_name" {
  description = "The DNS name of the VPC Endpoint."
  type        = string
}

variable "vpc_endpoint_zone_id" {
  description = "The ID of the Hosted Zone for the VPC Endpoint."
  type        = string
}

variable "evaluate_target_health" {
  type        = bool
  default     = false
  description = "whether or not Route 53 should perform health checks on the target of an alias record before responding to DNS queries."
}

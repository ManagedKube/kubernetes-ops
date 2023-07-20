
variable "route53_hosted_zone_id" {
  description = "Private hosted zone ID with which the VPCs must be associated with"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "List of VPC's IDs to associate with Route53 hostedzone"
  type        = any
  default     = []
}
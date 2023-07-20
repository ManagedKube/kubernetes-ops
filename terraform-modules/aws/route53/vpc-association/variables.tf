
# variable "route53_hosted_zone_id" {
#   description = "Private hosted zone ID with which the VPCs must be associated with"
#   type        = string
#   default     = null
# }

# variable "vpc_id" {
#   description = "Map of VPC IDs with their respective regions"
#   type        = map(object({
#     id     = string
#     region = string
#   }))
#   default     = {}
# }

variable "hosted_zone"{
    type = map(any)
    description = "Route53 hosted zone"
}
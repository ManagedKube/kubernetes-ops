variable "enable_deletion_protection" {
    type = bool
    description = "Enable deletion protection"
    default = false
}

variable "enable_internal" {
    type = bool
    description = "Enable internal load balancer"
    default = true
}

variable "nlb_name" {
    type = string
    description = "Network load balancer name"
    default = "test-nlb-tf"
}

variable "nlb_subnets" {
    type = list(string)
    description = "NLB Subnets"  
}

variable "enable_alb_access_logs" {
  description = "Set to true to enable the ALB to log all requests. Ideally, this variable wouldn't be necessary, but because Terraform can't interpolate dynamic variables in counts, we must explicitly include this. Enter true or false."
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Set enable_cross_zone_load_balancing"
  type = bool
  default = false
}

variable "enable_http2" {
    description = "enable_http2"
    type = bool
    default = false 
}

variable "nlb_access_logs_s3_bucket_name" {
    description = "nlb_access_logs_s3_bucket_name"
    type = string
    default = null  
}

variable "nlb_access_logs_s3_prefix" {
    description = "nlb_access_logs_s3_prefix"
    type = string
    default = null  
}

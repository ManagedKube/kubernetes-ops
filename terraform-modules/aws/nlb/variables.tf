variable "enable_deletion_protection" {
  type        = bool
  description = "Enable deletion protection"
  default     = false
}

variable "enable_internal" {
  type        = bool
  description = "Enable internal load balancer"
  default     = true
}

variable "nlb_name" {
  description = "The name of the NLB. Do not include the environment name since this module will automatically append it to the value of this variable."
  type        = string
  # AWS imposes a 32 character limit on the names of NLBs, so here we catch any overages client-side
  validation {
    condition     = length(var.nlb_name) <= 32
    error_message = "Your nlb_name must be 32 characters or less in length."
  }
}

variable "enable_nlb_access_logs" {
  description = "This is Optional, Only used to output the NLB logs to S3. we need to input bucket_name and bucket_prefix to the list. if left empty it will not output the logs to S3"
  type        = list(any)
  default     = []
}

variable "nlb_access_logs_s3_bucket_name" {
  description = "The S3 Bucket name where NLB logs should be stored. If left empty, no NLB logs will be captured. Tip: It's easiest to create the S3 Bucket using the Gruntwork Module https://github.com/gruntwork-io/terraform-aws-monitoring/tree/master/modules/logs/load-balancer-access-logs."
  type        = string
  default     = null
}

variable "custom_nlb_access_logs_s3_prefix" {
  description = "Prefix to use for access logs to create a sub-folder in S3 Bucket name where NLB logs should be stored. Only used if var.enable_custom_nlb_access_logs_s3_prefix is true."
  type        = string
  default     = null
}

variable "enable_custom_nlb_access_logs_s3_prefix" {
  description = "Set to true to use the value of nlb_access_logs_s3_prefix for access logs prefix. If false, the nlb_name will be used. This is useful if you wish to disable the S3 prefix. Only used if var.enable_nlb_access_logs is true."
  type        = bool
  default     = false
}

variable "access_logs_s3_bucket_name" {
  description = "The name to use for the S3 bucket where the NLB access logs will be stored. If you set this to null, a name will be generated automatically based on var.nlb_name."
  type        = string
  default     = null
}

variable "should_create_access_logs_bucket" {
  description = "If true, create a new S3 bucket for access logs with the name in var.access_logs_s3_bucket_name. If false, assume the S3 bucket for access logs with the name in  var.access_logs_s3_bucket_name already exists, and don't create a new one. Note that if you set this to false, it's up to you to ensure that the S3 bucket has a bucket policy that grants Elastic Load Balancing permission to write the access logs to your bucket."
  type        = bool
  default     = true
}

variable "num_days_after_which_archive_log_data" {
  description = "After this number of days, log files should be transitioned from S3 to Glacier. Enter 0 to never archive log data."
  type        = number
}

variable "num_days_after_which_delete_log_data" {
  description = "After this number of days, log files should be deleted from S3. Enter 0 to never delete log data."
  type        = number
}

variable "force_destroy" {
  description = "A boolean that indicates whether the access logs bucket should be destroyed, even if there are files in it, when you run Terraform destroy. Unless you are using this bucket only for test purposes, you'll want to leave this variable set to false."
  type        = bool
  default     = false
}

variable "nlb_subnets" {
  type        = list(string)
  description = "NLB Subnets"
}


variable "enable_cross_zone_load_balancing" {
  description = "Set enable_cross_zone_load_balancing"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "enable_http2"
  type        = bool
  default     = false
}


variable "nlb_access_logs_s3_prefix" {
  description = "nlb_access_logs_s3_prefix"
  type        = string
  default     = null
}

variable "nlb_s3_bucket_name" {
  description = "nlb_s3_bucket_name"
  type        = string
  default     = null
}

variable "nlb_target_ips" {
  description = "Set true if you need to create target groups with Ips"
  type        = bool
  default     = false
}

variable "target_ips" {
  description = "Set a list of ips with ports if you set `nlb_target_ips` equalss true (only if `nlb_target_ips` equals true)"
  type = set(object({
    ip_address = string
    port       = number
  }))
  default  = []
}

variable "deregistration_delay" {
  type        = number
  default     = 15
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused (only if `nlb_target_ips` equals true)"
}

variable "target_group_name" {
  type        = string
  default     = ""
  description = "The name for the default target group, uses a module label name if left empty (only if `nlb_target_ips` equals true)"
}

variable "target_group_port" {
  type        = number
  default     = 80
  description = "The port for the default target group (only if `nlb_target_ips` equals true)"
}

variable "target_group_target_type" {
  type        = string
  default     = "ip"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the default target group (only if `nlb_target_ips` equals true)"
}

variable "target_group_proxy_protocol_v2" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable proxy protocol v2 support (only if `nlb_target_ips` equals true)"
}

variable "slow_start" {
  type        = number
  default     = 0
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. (only if `nlb_target_ips` equals true)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with Target Group (only if `nlb_target_ips` equals true)"
}

variable "health_check_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable the NLB health checks (only if `nlb_target_ips` equals true)"
}

variable "health_check_port" {
  type        = number
  default     = null
  description = "The port to send the health check request to (defaults to `traffic-port`) (only if `nlb_target_ips` equals true)"
}

variable "health_check_protocol" {
  type        = string
  default     = null
  description = "The protocol to use for the health check request (only if `nlb_target_ips` equalss true)"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination for the health check request (only if `nlb_target_ips` equals true)"
}

variable "health_check_threshold" {
  type        = number
  default     = 2
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy. (only if `nlb_target_ips` equals true)"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = null
  description = "The number of consecutive health check failures required before considering the target unhealthy. If not set using value from `health_check_threshold` (only if `nlb_target_ips` equals true)"
}

variable "health_check_interval" {
  type        = number
  default     = 10
  description = "The duration in seconds in between health checks (only if `nlb_target_ips` equals true)"
}

variable "listener_port" {
  Type      = number
  default   = 80
  description = "Set listener port to forwarding (only if `nlb_target_ips` equals true)"
}

variable "nlb_tags" {
  description = "Tags"
  type        = map(any)
  default = {
    appname = "nlb"
  }
}
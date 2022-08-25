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
  description = "The name of the NLB. Do not include the environment name since this module will automatically append it to the value of this variable."
  type        = string
  # AWS imposes a 32 character limit on the names of ALBs, so here we catch any overages client-side
  validation {
    condition     = length(var.nlb_name) <= 32
    error_message = "Your alb_name must be 32 characters or less in length."
  }
}

variable "enable_nlb_access_logs" {
  description = "Set to true to enable the ALB to log all requests. Ideally, this variable wouldn't be necessary, but because Terraform can't interpolate dynamic variables in counts, we must explicitly include this. Enter true or false."
  type        = bool
  default     = false
}

variable "nlb_access_logs_s3_bucket_name" {
  description = "The S3 Bucket name where ALB logs should be stored. If left empty, no ALB logs will be captured. Tip: It's easiest to create the S3 Bucket using the Gruntwork Module https://github.com/gruntwork-io/terraform-aws-monitoring/tree/master/modules/logs/load-balancer-access-logs."
  type        = string
  default     = null
}

variable "custom_nlb_access_logs_s3_prefix" {
  description = "Prefix to use for access logs to create a sub-folder in S3 Bucket name where ALB logs should be stored. Only used if var.enable_custom_alb_access_logs_s3_prefix is true."
  type        = string
  default     = null
}

variable "enable_custom_nlb_access_logs_s3_prefix" {
  description = "Set to true to use the value of alb_access_logs_s3_prefix for access logs prefix. If false, the alb_name will be used. This is useful if you wish to disable the S3 prefix. Only used if var.enable_alb_access_logs is true."
  type        = bool
  default     = false
}

variable "access_logs_s3_bucket_name" {
  description = "The name to use for the S3 bucket where the ALB access logs will be stored. If you set this to null, a name will be generated automatically based on var.alb_name."
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


variable "nlb_access_logs_s3_prefix" {
    description = "nlb_access_logs_s3_prefix"
    type = string
    default = null  
}

variable "nlb_s3_bucket_name" {
    description = "nlb_s3_bucket_name"
    type = string
    default = null   
  
}
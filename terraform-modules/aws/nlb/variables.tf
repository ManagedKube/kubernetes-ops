variable "enable_deletion_protection" {
  type        = bool
  description = "Set to true to enable deletion protection for the NLB."
  default     = false
}

variable "enable_internal" {
  type        = bool
  description = "Set to true to create an internal load balancer, otherwise set to false for a public load balancer."
  default     = true
}

variable "nlb_name" {
  description = "The name of the Network Load Balancer (NLB). It should be 32 characters or less."
  type        = string
  validation {
    condition     = length(var.nlb_name) <= 32
    error_message = "Your nlb_name must be 32 characters or less in length."
  }
}

variable "enable_nlb_access_logs" {
  description = "Set to a list containing bucket_name and bucket_prefix to enable NLB access logs. Leave empty to disable NLB access logs to S3."
  type        = list(any)
  default     = []
}

variable "nlb_access_logs_s3_bucket_name" {
  description = "The name of the S3 bucket where NLB logs should be stored. Leave empty to disable NLB access logs."
  type        = string
  default     = null
}

variable "custom_nlb_access_logs_s3_prefix" {
  description = "Prefix to use for NLB access logs in the S3 bucket. Used if enable_custom_nlb_access_logs_s3_prefix is set to true."
  type        = string
  default     = null
}

variable "enable_custom_nlb_access_logs_s3_prefix" {
  description = "Set to true to use custom_nlb_access_logs_s3_prefix for access logs. Set to false to use nlb_name as the prefix."
  type        = bool
  default     = false
}

variable "access_logs_s3_bucket_name" {
  description = "The name of the S3 bucket for storing NLB access logs. Leave it null to auto-generate based on nlb_name."
  type        = string
  default     = null
}

variable "should_create_access_logs_bucket" {
  description = "Set to true to create a new S3 bucket for access logs. Set to false if the bucket already exists."
  type        = bool
  default     = true
}

variable "num_days_after_which_archive_log_data" {
  description = "The number of days after which log files should be archived to Glacier. Set to 0 to never archive log data."
  type        = number
}

variable "num_days_after_which_delete_log_data" {
  description = "The number of days after which log files should be deleted from S3. Set to 0 to never delete log data."
  type        = number
}

variable "force_destroy" {
  description = "Set to true to allow the access logs bucket to be destroyed during Terraform destroy, even if it contains files. Set to false for safety."
  type        = bool
  default     = false
}

variable "nlb_subnets" {
  type        = list(string)
  description = "List of subnets where the NLB will be deployed."
}

variable "enable_cross_zone_load_balancing" {
  description = "Set to true to enable cross-zone load balancing for the NLB."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Set to true to enable HTTP/2 for the NLB."
  type        = bool
  default     = false
}

variable "nlb_access_logs_s3_prefix" {
  description = "The prefix used for NLB access logs in the S3 bucket. Leave it null to use the default prefix."
  type        = string
  default     = null
}

variable "nlb_s3_bucket_name" {
  description = "The name of the S3 bucket for NLB-related resources."
  type        = string
  default     = null
}

variable "nlb_tags" {
  description = "A map of tags to apply to the NLB resource."
  type        = map(any)
  default     = {
    appname = "nlb"
  }
}

# Target Groups Variables
variable "target_group_name" {
  description = "The name of the Target Group."
}

variable "target_group_port" {
  description = "The port on which the Target Group listens."
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "The protocol used by the Target Group."
  type        = string
  default     = "HTTP"
}

variable "target_vpc_id" {
  description = "The VPC where the targets' endpoints are deployed."
  type        = string
}

variable "tg_attachment_ip_1" {
  description = "The IP address of the first target to attach to the Target Group."
  type        = string
}

variable "tg_attachment_port_1" {
  description = "The port number on which the first target listens, used for attaching to the Target Group."
  type        = number
}

variable "tg_attachment_ip_2" {
  description = "The IP address of the second target to attach to the Target Group."
  type        = string
}

variable "tg_attachment_port_2" {
  description = "The port number on which the second target listens, used for attaching to the Target Group."
  type        = number
}

variable "listener_port" {
  description = "The port on which the listener listens."
  type        = string
  default     = "80"
}

variable "listener_protocol" {
  description = "The protocol used by the listener."
  type        = string
  default     = "HTTP"
}
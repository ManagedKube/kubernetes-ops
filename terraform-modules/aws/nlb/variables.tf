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

variable "nlb_security_groups" {
  description = "Security Group to filter traffict to load balancer"
  type        = list(string)
}

variable "enable_nlb_access_logs" {
  description = "Set to a list containing bucket_name and bucket_prefix to enable NLB access logs. Leave empty to disable NLB access logs to S3."
  type        = list(any)
  default     = []
}

variable "nlb_subnets" {
  type    = list(any)
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

variable "target_attachments" {
  type = list(object({
    target_id = string
    port      = number
  }))
  description = "List of target attachments"
}
variable "guardduty_enabled" {
  description = "Enable or disable AWS GuardDuty"
  type        = bool
  default     = true
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "guardduty-topic"
}

variable "event_rule_name" {
  description = "Name of the CloudWatch Events rule"
  type        = string
  default     = "GuardDutyFindingRule"
}

variable "event_rule_description" {
  description = "Description of the CloudWatch Events rule"
  type        = string
  default     = "Event rule for GuardDuty findings"
}

variable "event_target_id" {
  description = "Identifier for the CloudWatch Events target"
  type        = string
  default     = "GuardDutySNSTarget"
}

variable "subscription_protocol" {
  description = "Protocol for the SNS topic subscription"
  type        = string
  default     = "email"
}

variable "subscription_endpoints" {
  description = "List of email addresses to receive notifications"
  type        = list(string)
  default     = [
    "xxxx@domain.com"
  ]
}

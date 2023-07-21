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

variable "event_pattern" {
  type        = string
  description = <<-EOT
      {
        "source"      : ["aws.guardduty"],
        "detail-type" : ["GuardDuty Finding"]
    }
  EOT
}
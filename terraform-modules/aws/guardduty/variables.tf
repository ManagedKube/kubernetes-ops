variable guardduty_enabled {
  type        = bool
  default     = true
  description = "Enable monitoring and feedback reporting. Setting to false is equivalent to suspending GuardDuty. Defaults to true."
}

variable "guardduty_s3_logs_enabled" {
  type        = bool
  default     = false
  description = "Configures S3 protection. See S3 Logs below for more details."
}

variable "guardduty_malware_protection_logs_enabled" {
  type        = bool
  default     = false
  description = "Configures Malware Protection. See Malware Protection, Scan EC2 instance with findings and EBS volumes."
}

 variable "tags" {
  description = "tags for Guard Duty"
  type    = map(any)
  default = {}
}

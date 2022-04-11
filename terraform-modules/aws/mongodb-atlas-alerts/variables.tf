variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "default_alerts" {
  type        = list(any)
  default     = [
    {
      event_type = "OUTSIDE_METRIC_THRESHOLD"
      enabled = true
      notification = [
        {
          type_name = "GROUP"
          interval_min  = 5
          delay_min     = 0
          sms_enabled   = false
          email_enabled = true
          roles = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
        },
        {
          type_name     = "ORG"
          interval_min  = 5
          delay_min     = 0
          sms_enabled   = true
          email_enabled = false
        },
      ]
    },
  ]
  description = "description"
}

variable "user_alerts" {
  type        = string
  default     = ""
  description = "description"
}


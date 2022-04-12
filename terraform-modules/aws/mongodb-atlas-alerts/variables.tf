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
      matcher = {
        field_name = "HOSTNAME_AND_PORT"
        operator   = "EQUALS"
        value      = "SECONDARY"
      }
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      # If event_type is set to OUTSIDE_METRIC_THRESHOLD, the metric_threshold_config field must also be set
      metric_threshold_config = [
        {
          metric_name = "ASSERT_REGULAR"
          operator    = "LESS_THAN"
          threshold   = 99.0
          units       = "RAW"
          mode        = "AVERAGE"
        }
      ]
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    # User joins group
    {
      event_type = "JOINED_GROUP"
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
      matcher = {
        field_name = "HOSTNAME_AND_PORT"
        operator   = "EQUALS"
        value      = "SECONDARY"
      }
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = [
        {
          operator    = "LESS_THAN"
          threshold   = 1
          units       = "HOURS"
        }
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


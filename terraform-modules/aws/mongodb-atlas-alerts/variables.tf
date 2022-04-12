variable "mongodbatlas_projectid" {
  type        = string
  description = "The unique ID for the project to create the database user."
}

variable "use_global_notification_settings" {
  type        = bool
  default     = true
  description = "This will override all notification settings with the global_notification_settings variable"
}

variable "global_notification_settings" {
  type        = list(any)
  default     = [
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
  description = "Global notification setting that is applied to all alerts created by this module"
}


# Alerts vars: https://www.mongodb.com/docs/atlas/reference/api/alert-configurations-create-config/#request-body-parameters
# MongoDB Host Metric reference: https://www.mongodb.com/docs/atlas/reference/alert-host-metrics/
variable "default_alerts" {
  type        = list(any)
  default     = [
    # {
    #   event_type = "OUTSIDE_METRIC_THRESHOLD"
    #   enabled = true
    #   notification = [
    #     {
    #       type_name = "GROUP"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = false
    #       email_enabled = true
    #       roles = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
    #     },
    #     {
    #       type_name     = "ORG"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = true
    #       email_enabled = false
    #     },
    #   ]
    #   # This is the #2 in the edit alert
    #   matcher = {
    #     field_name = "HOSTNAME_AND_PORT"
    #     operator   = "EQUALS"
    #     value      = "SECONDARY"
    #   }
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   # If event_type is set to OUTSIDE_METRIC_THRESHOLD, the metric_threshold_config field must also be set
    #   metric_threshold_config = [
    #     {
    #       metric_name = "ASSERT_REGULAR"
    #       operator    = "LESS_THAN"
    #       threshold   = 99.0
    #       units       = "RAW"
    #       mode        = "AVERAGE"
    #     }
    #   ]
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   threshold_config = []
    # },
    # # User joined the project 
    # {
    #   event_type = "JOINED_GROUP"
    #   enabled = true
    #   notification = [
    #     {
    #       type_name = "GROUP"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = false
    #       email_enabled = true
    #       roles = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
    #     },
    #     {
    #       type_name     = "ORG"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = true
    #       email_enabled = false
    #     },
    #   ]
    #   matcher = {
    #     field_name = "HOSTNAME_AND_PORT"
    #     operator   = "EQUALS"
    #     value      = "SECONDARY"
    #   }
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   metric_threshold_config = []
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   threshold_config = []
    # },
    # # Insufficient disk space to support rebuilding search indexes 
    # {
    #   event_type = "OUTSIDE_METRIC_THRESHOLD"
    #   enabled = true
    #   notification = [
    #     {
    #       type_name = "GROUP"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = false
    #       email_enabled = true
    #       roles = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
    #     },
    #     {
    #       type_name     = "ORG"
    #       interval_min  = 5
    #       delay_min     = 0
    #       sms_enabled   = true
    #       email_enabled = false
    #     },
    #   ]
    #   matcher = {
    #     field_name = "HOSTNAME_AND_PORT"
    #     operator   = "EQUALS"
    #     value      = "SECONDARY"
    #   }
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   metric_threshold_config = [
    #     {
    #       metric_name = "ASSERT_REGULAR"
    #       operator    = "LESS_THAN"
    #       threshold   = 99.0
    #       units       = "RAW"
    #       mode        = "AVERAGE"
    #     }
    #   ]
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   threshold_config = []
    # },









    {
      event_type = "REPLICATION_OPLOG_WINDOW_RUNNING_OUT"
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


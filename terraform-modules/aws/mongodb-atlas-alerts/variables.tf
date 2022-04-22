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
  type = list(any)
  # The items in the list all has to have the same number of items or the apply will fail
  # due to Terraform deaming the items in the list being inconsistent
  default = [
    {
      type_name     = "GROUP"
      interval_min  = 5
      delay_min     = 0
      sms_enabled   = false
      email_enabled = true
      roles         = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
    },
    {
      type_name     = "ORG"
      interval_min  = 5
      delay_min     = 0
      sms_enabled   = true
      email_enabled = false
      roles         = []
    },
  ]
  description = "Global notification setting that is applied to all alerts created by this module"
}

variable "enable_default_alerts" {
  type        = bool
  default     = true
  description = "To use the set of default alerts or not"
}

# Alerts vars: https://www.mongodb.com/docs/atlas/reference/api/alert-configurations-create-config/#request-body-parameters
# MongoDB Host Metric reference: https://www.mongodb.com/docs/atlas/reference/alert-host-metrics/
variable "default_alerts" {
  type = list(any)
  default = [
    {
      event_type   = "REPLICATION_OPLOG_WINDOW_RUNNING_OUT"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = [
        {
          operator  = "LESS_THAN"
          threshold = 1
          units     = "HOURS"
        }
      ]
    },
    {
      event_type   = "NO_PRIMARY"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "CLUSTER_MONGOS_IS_MISSING"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "OUTSIDE_METRIC_THRESHOLD"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = [
        {
          metric_name = "CONNECTIONS_PERCENT"
          operator    = "GREATER_THAN"
          threshold   = 80
          units       = "RAW"
          mode        = "AVERAGE"
        }
      ]
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "OUTSIDE_METRIC_THRESHOLD"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = [
        {
          metric_name = "DISK_PARTITION_SPACE_USED_DATA"
          operator    = "GREATER_THAN"
          threshold   = 90
          units       = "RAW"
          mode        = "AVERAGE"
        }
      ]
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "OUTSIDE_METRIC_THRESHOLD"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = [
        {
          metric_name = "QUERY_TARGETING_SCANNED_OBJECTS_PER_RETURNED"
          operator    = "GREATER_THAN"
          threshold   = 1000
          units       = "RAW"
          mode        = "AVERAGE"
        }
      ]
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "CREDIT_CARD_ABOUT_TO_EXPIRE"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "OUTSIDE_METRIC_THRESHOLD"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = [
        {
          metric_name = "NORMALIZED_SYSTEM_CPU_USER"
          operator    = "GREATER_THAN"
          threshold   = 95
          units       = "RAW"
          mode        = "AVERAGE"
        }
      ]
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "HOST_HAS_INDEX_SUGGESTIONS"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "HOST_MONGOT_CRASHING_OOM"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    # These alerts didnt work when trying to apply it.  Leaving it out for now.
    # Returned a nondescriptive generic error.
    # {
    #   event_type   = "OUTSIDE_SERVERLESS_METRIC_THRESHOLD"
    #   enabled      = true
    #   notification = []
    #   matcher      = []
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   metric_threshold_config = []
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   threshold_config = [
    #     {
    #       metric_name = "SERVERLESS_CONNECTIONS_PERCENT"
    #       operator    = "GREATER_THAN"
    #       threshold   = 80
    #       units       = "RAW"
    #       mode        = "AVERAGE"
    #     }
    #   ]
    # },
    # {
    #   event_type   = "OUTSIDE_SERVERLESS_METRIC_THRESHOLD"
    #   enabled      = true
    #   notification = []
    #   matcher      = []
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   metric_threshold_config = []
    #   # This can only be a list of 1
    #   # If is "metric_threshold_config" set, then "threshold_config" is not needed
    #   threshold_config = [
    #     {
    #       metric_name = "SERVERLESS_DATA_SIZE_TOTAL"
    #       operator    = "GREATER_THAN"
    #       threshold   = 0.75
    #       units       = "TERABYTES"
    #       mode        = "AVERAGE"
    #     }
    #   ]
    # },
    {
      event_type   = "HOST_NOT_ENOUGH_DISK_SPACE"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
    {
      event_type   = "JOINED_GROUP"
      enabled      = true
      notification = []
      matcher      = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      metric_threshold_config = []
      # This can only be a list of 1
      # If is "metric_threshold_config" set, then "threshold_config" is not needed
      threshold_config = []
    },
  ]
  description = "description"
}

variable "user_alerts" {
  type        = string
  default     = ""
  description = "description"
}


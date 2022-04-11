
terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.0.1"
    }
  }
}

locals {
    all_alerts = "merge of the default and user alerts"
}

resource "mongodbatlas_alert_configuration" "defaults" {
  project_id = var.mongodbatlas_projectid
  event_type = "OUTSIDE_METRIC_THRESHOLD"
  enabled    = true

  notification {
    type_name     = "GROUP"
    interval_min  = 5
    delay_min     = 0
    sms_enabled   = false
    email_enabled = true
    roles = ["GROUP_DATA_ACCESS_READ_ONLY", "GROUP_CLUSTER_MANAGER", "GROUP_DATA_ACCESS_ADMIN"]
  }

  notification {
    type_name     = "ORG"
    interval_min  = 5
    delay_min     = 0
    sms_enabled   = true
    email_enabled = false
  }

  matcher {
    field_name = "HOSTNAME_AND_PORT"
    operator   = "EQUALS"
    value      = "SECONDARY"
  }

  metric_threshold_config {
    metric_name = "ASSERT_REGULAR"
    operator    = "LESS_THAN"
    threshold   = 99.0
    units       = "RAW"
    mode        = "AVERAGE"
  }
}

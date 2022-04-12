
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
  count = length(var.default_alerts)

  project_id = var.mongodbatlas_projectid
  event_type = var.default_alerts[count.index].event_type
  enabled    = var.default_alerts[count.index].enabled

  dynamic "notification" {
    for_each = var.default_alerts[count.index].notification
    content {
      type_name     = try(notification.value.type_name, null)
      interval_min  = try(notification.value.interval_min, null)
      delay_min     = try(notification.value.delay_min, null)
      sms_enabled   = try(notification.value.sms_enabled, null)
      email_enabled = try(notification.value.email_enabled, null)
      roles = try(notification.value.roles, null)
    }
  }

  matcher {
    field_name = var.default_alerts[count.index].matcher.field_name
    operator   = var.default_alerts[count.index].matcher.operator
    value      = var.default_alerts[count.index].matcher.value
  }

  metric_threshold_config {
    metric_name = var.default_alerts[count.index].metric_threshold_config.metric_name
    operator    = var.default_alerts[count.index].metric_threshold_config.operator
    threshold   = var.default_alerts[count.index].metric_threshold_config.threshold
    units       = var.default_alerts[count.index].metric_threshold_config.units
    mode        = var.default_alerts[count.index].metric_threshold_config.mode
  }

  dynamic "threshold_config" {
    for_each = var.default_alerts[count.index].threshold_config
    content {
      operator    = try(threshold_config.value.operator, null)
      threshold   = try(threshold_config.value.threshold, null)
      units       = try(threshold_config.value.units, null)
    }
  }
}

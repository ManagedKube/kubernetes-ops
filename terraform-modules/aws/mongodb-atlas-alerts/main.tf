
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
    for_each = var.use_global_notification_settings ? var.global_notification_settings : var.default_alerts[count.index].notification
    content {
      type_name     = try(var.use_global_notification_settings ? var.global_notification_settings.type_name : notification.value.type_name, null)
      interval_min  = try(var.use_global_notification_settings ? var.global_notification_settings.interval_min : notification.value.interval_min, null)
      delay_min     = try(var.use_global_notification_settings ? var.global_notification_settings.delay_min : notification.value.delay_min, null)
      sms_enabled   = try(var.use_global_notification_settings ? var.global_notification_settings.sms_enabled : notification.value.sms_enabled, null)
      email_enabled = try(var.use_global_notification_settings ? var.global_notification_settings.email_enabled : notification.value.email_enabled, null)
      roles = try(notification.value.roles, null)
    }
  }

  matcher {
    field_name = var.default_alerts[count.index].matcher.field_name
    operator   = var.default_alerts[count.index].matcher.operator
    value      = var.default_alerts[count.index].matcher.value
  }

  dynamic "metric_threshold_config" {
    for_each = var.default_alerts[count.index].metric_threshold_config
    content {
      metric_name = metric_threshold_config.value.metric_name
      operator    = metric_threshold_config.value.operator
      threshold   = metric_threshold_config.value.threshold
      units       = metric_threshold_config.value.units
      mode        = metric_threshold_config.value.mode
    }
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
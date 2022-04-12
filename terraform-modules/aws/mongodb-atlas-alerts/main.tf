
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
  count = var.enable_default_alerts ? length(var.default_alerts) : 0

  project_id = var.mongodbatlas_projectid
  event_type = var.default_alerts[count.index].event_type
  enabled    = var.default_alerts[count.index].enabled

  dynamic "notification" {
    for_each = var.use_global_notification_settings ? var.global_notification_settings : var.default_alerts[count.index].notification
    content {
      type_name              = try(notification.value.type_name, null)
      interval_min           = try(notification.value.interval_min, null)
      delay_min              = try(notification.value.delay_min, null)
      sms_enabled            = try(notification.value.sms_enabled, null)
      email_enabled          = try(notification.value.email_enabled, null)
      roles                  = try(notification.value.roles, null)
      api_token              = try(notification.value.api_token, null)
      channel_name           = try(notification.value.channel_name, null)
      datadog_region         = try(notification.value.datadog_region, null)
      email_address          = try(notification.value.email_address, null)
      flowdock_api_token     = try(notification.value.flowdock_api_token, null)
      flow_name              = try(notification.value.flow_name, null)
      mobile_number          = try(notification.value.mobile_number, null)
      ops_genie_api_key      = try(notification.value.ops_genie_api_key, null)
      ops_genie_region       = try(notification.value.ops_genie_region, null)
      # team_id                = try(notification.value.team_id, null)
      # team_name              = try(notification.value.team_name, null)
      username               = try(notification.value.username, null)
      victor_ops_api_key     = try(notification.value.victor_ops_api_key, null)
      victor_ops_routing_key = try(notification.value.victor_ops_routing_key, null)
    }
  }

  dynamic "matcher" {
    for_each = var.default_alerts[count.index].matcher
    content {
      field_name = matcher.value.field_name
      operator   = matcher.value.operator
      value      = matcher.value.value
    }
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
      operator  = try(threshold_config.value.operator, null)
      threshold = try(threshold_config.value.threshold, null)
      units     = try(threshold_config.value.units, null)
    }
  }
}

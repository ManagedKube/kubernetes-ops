locals {
    alb_access_logs_s3_prefix = (
    var.enable_custom_alb_access_logs_s3_prefix    ? var.custom_alb_access_logs_s3_prefix    : var.alb_name
  )
}
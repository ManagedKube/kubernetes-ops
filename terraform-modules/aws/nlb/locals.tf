# ---------------------------------------------------------------------------------------------------------------------
# LOCAL VALUES USED THROUGHOUT THE MODULE
# ---------------------------------------------------------------------------------------------------------------------

locals {

  nlb_access_logs_s3_prefix = (
    var.enable_custom_nlb_access_logs_s3_prefix
    ? var.custom_nlb_access_logs_s3_prefix
    : var.nlb_name
  )

}
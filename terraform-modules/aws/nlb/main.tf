resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = var.enable_internal 
  load_balancer_type = "network"
  subnets            = var.nlb_subnets

  enable_deletion_protection = var.enable_deletion_protection

dynamic "access_logs" {
    # The contents of the list is irrelevant. The only important thing is whether or not to create this block.
    for_each = var.enable_nlb_access_logs ? ["use_access_logs"] : []
    content {
      bucket  = var.nlb_s3_bucket_name
      prefix  = local.nlb_access_logs_s3_prefix
      enabled = true
    }
  }


 enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

 enable_http2 = var.enable_http2

  tags = {
    Environment = "Ops"
  }
#   depends_on = [
#     module.nlb_access_logs_bucket
#   ]
}


# Create an S3 Bucket to store ALB access logs.
# module "nlb_access_logs_bucket" {
#   source = "git::git@github.com:gruntwork-io/terraform-aws-monitoring.git//modules/logs/load-balancer-access-logs?ref=v0.35.3"

#   # Try to do some basic cleanup to get a valid S3 bucket name: the name must be lower case and can only contain
#   # lowercase letters, numbers, and hyphens. For the full rules, see:
#   # http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html#bucketnamingrules
#   s3_bucket_name = (
#     var.access_logs_s3_bucket_name != null
#     ? var.access_logs_s3_bucket_name
#     : "nlb-${lower(replace(var.nlb_name, "_", "-"))}-access-logs"
#   )
#   s3_logging_prefix = var.nlb_name

#   num_days_after_which_archive_log_data = var.num_days_after_which_archive_log_data
#   num_days_after_which_delete_log_data  = var.num_days_after_which_delete_log_data

#   force_destroy    = var.force_destroy
#   create_resources = var.should_create_access_logs_bucket
# }

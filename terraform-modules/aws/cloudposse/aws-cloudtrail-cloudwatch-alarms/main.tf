## Everything after this is standard cloudtrail setup
data "aws_caller_identity" "current" {}

module "cloudtrail_s3_bucket" {
  source  = "ManagedKube/cloudtrail-s3-bucket/aws"
  version = "master"
  force_destroy          = var.force_destroy
  versioning_enabled     = var.versioning_enabled
  access_log_bucket_name = var.access_log_bucket_name
  allow_ssl_requests_only= var.allow_ssl_requests_only
  acl                    = var.acl
  s3_object_ownership    = var.s3_object_ownership
  context = module.this.context
}

resource "aws_cloudwatch_log_group" "default" {
  name              = module.this.id
  tags              = module.this.tags
  retention_in_days = 90
}

data "aws_iam_policy_document" "log_policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.default.name}:log-stream:*"
    ]
  }
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name               = lower(join(module.this.delimiter, [module.this.id, "role"]))
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  tags               = module.this.tags
}

resource "aws_iam_role_policy" "policy" {
  name   = lower(join(module.this.delimiter, [module.this.id, "policy"]))
  policy = data.aws_iam_policy_document.log_policy.json
  role   = aws_iam_role.cloudtrail_cloudwatch_events_role.id
}

module "metric_configs" {
  source  = "cloudposse/config/yaml"
  version = "0.7.0"

  map_config_local_base_path = path.module
  map_config_paths           = var.metrics_paths

  context = module.this.context
}

module "cloudtrail" {
  source                        = "cloudposse/cloudtrail/aws"
  version                       = "0.17.0"
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  s3_bucket_name = module.cloudtrail_s3_bucket.bucket_id
  # https://github.com/terraform-providers/terraform-provider-aws/issues/14557#issuecomment-671975672
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.default.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_events_role.arn
  event_selector = var.cloudtrail_event_selector
  context = module.this.context
}

## This is the module being used
module "cis_alarms" {
  source         = "cloudposse/cloudtrail-cloudwatch-alarms/aws"
  version        = "0.14.3"
  log_group_name = aws_cloudwatch_log_group.default.name
  metrics        = module.metric_configs.map_configs
}
locals {
  arn_format  = "arn:${data.aws_partition.current.partition}"
}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

## Everything after this is standard cloudtrail setup
/*ToDo: We are collaborating with cloudposse to bring this solution to your project, we have the task of following up this pr to integrate it 
          and return to the direct version of cloudposse.
          
          Cloudposse' issue: New input variable s3_object_ownership cloudposse/terraform-aws-cloudtrail-s3-bucket#62
          Cloudposse' pr: add input var s3_object_ownership cloudposse/terraform-aws-cloudtrail-s3-bucket#63
*/

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A KMS 
# We can attach KMS to CloudWatch Log.
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable Root User Permissions"
    effect = "Allow"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:Tag*",
      "kms:Untag*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    #bridgecrew:skip=CKV_AWS_109:This policy applies only to the key it is attached to
    #bridgecrew:skip=CKV_AWS_111:This policy applies only to the key it is attached to
    resources = [
      "*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        "${local.arn_format}:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    sid    = "Allow KMS to CloudWatch Log Group ${element(var.attributes,0)}"
    effect = "Allow"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
    condition {
      test = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${${element(var.attributes,0)}"]
    }
  }
}

resource "aws_kms_key" "kms" {
  description             = "KMS key for ${element(var.attributes,0)"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = join("", data.aws_iam_policy_document.kms.*.json)
}

module "cloudtrail_s3_bucket" {
  source  = "github.com/ManagedKube/terraform-aws-cloudtrail-s3-bucket.git//?ref=0.24.0"
  #version = "master"
  force_destroy          = var.force_destroy
  versioning_enabled     = var.versioning_enabled
  access_log_bucket_name = var.access_log_bucket_name
  allow_ssl_requests_only= var.allow_ssl_requests_only
  acl                    = var.acl
  s3_object_ownership    = var.s3_object_ownership
  sse_algorithm          = "aws:kms"
  context = module.this.context
}

resource "aws_cloudwatch_log_group" "default" {
  name              = module.this.id
  tags              = module.this.tags
  retention_in_days = 365
  #prowler issue: https://github.com/prowler-cloud/prowler/issues/1229
  kms_key_id = aws_kms_key.kms.arn
}

data "aws_iam_policy_document" "log_policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream","logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.default.name}:*:*"
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
  is_multi_region_trail         = var.is_multi_region_trail
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
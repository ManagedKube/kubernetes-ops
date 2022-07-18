# This is a standard kms that frees any cloud watch log group from vulnerabilities.
# Docs: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html

locals {
  arn_format  = "arn:${data.aws_partition.current.partition}"
}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
    sid    = "Allow KMS to CloudWatch Log Group ${var.log_group_name}"
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
      values = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}"]
    }
  }
}

resource "aws_kms_key" "kms" {
  description             = "KMS key for log-group: ${var.log_group_name}"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = var.kms_enable_key_rotation
  policy                  = join("", data.aws_iam_policy_document.kms.*.json)
  tags                    = var.tags
}

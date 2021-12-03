locals {
  name = "loki-stack"
}

resource "aws_kms_key" "loki-stack" {
  description             = "${local.name}-${var.cluster_name}"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "loki-stack" {
  bucket = "${local.name}-${var.cluster_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.loki-stack.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [aws_kms_key.loki-stack]
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "loki-stack-${var.cluster_name}"
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.loki-stack.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:monitoring:${local.name}"]
}

resource "aws_iam_policy" "loki-stack" {
  name_prefix = "${local.name}-${var.cluster_name}"
  description = "IAM policy for ${local.name}"
  policy      = data.aws_iam_policy_document.loki-stack.json
}

data "aws_iam_policy_document" "loki-stack" {
  statement {
    sid    = replace(local.name, "-", "")
    effect = "Allow"

    # https://grafana.com/docs/loki/latest/operations/storage/
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:ListTagsOfResource",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable"
    ]

    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}

#
# Helm - ${local.name}
#
data "template_file" "helm_values" {
  template = file("${path.module}/values.yaml")
  vars = {
    s3           = aws_s3_bucket.loki-stack.bucket
    awsAccountID = data.aws_caller_identity.current.account_id
    awsRegion    = var.aws_region
    clusterName  = var.cluster_name
  }
}

module "loki" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.30"

  repository          = "https://grafana.github.io/helm-charts"
  official_chart_name = local.name
  user_chart_name     = local.name
  helm_version        = "2.5.0"
  namespace           = "monitoring"
  helm_values         = data.template_file.helm_values.rendered

  depends_on = [
    aws_s3_bucket.loki-stack, aws_iam_policy.loki-stack
  ]
}

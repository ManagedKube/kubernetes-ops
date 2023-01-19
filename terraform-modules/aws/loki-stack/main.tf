locals {
  # name = "loki-stack"
  name          = "loki-distributed"
  name_promtail = "promtail"
}

resource "aws_s3_bucket" "loki-stack" {
  bucket = "${local.name}-${var.cluster_name}"
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.loki-stack.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.loki-stack.id
  acl    = "private"
}

# Using the default AWS KMS master key in your account
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.loki-stack.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256" #"aws:kms"
    }
  }
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
    # sid    = replace(local.name, "-", "")
    effect = "Allow"

    # https://grafana.com/docs/loki/latest/operations/storage/
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.loki-stack.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.loki-stack.bucket}/*",
    ]
  }
  
  ## We are using Grafana boltdb-shipper which will put the logs and index in the same S3 location
  ## Which means that DynamoDB is not required
  # statement {
  #   # sid    = replace(local.name, "-", "")
  #   effect = "Allow"

  #   # https://grafana.com/docs/loki/latest/operations/storage/
  #   actions = [
  #     "dynamodb:ListTables",
  #     "dynamodb:BatchGetItem",
  #     "dynamodb:BatchWriteItem",
  #     "dynamodb:DeleteItem",
  #     "dynamodb:DescribeTable",
  #     "dynamodb:GetItem",
  #     "dynamodb:ListTagsOfResource",
  #     "dynamodb:PutItem",
  #     "dynamodb:Query",
  #     "dynamodb:TagResource",
  #     "dynamodb:UntagResource",
  #     "dynamodb:UpdateItem",
  #     "dynamodb:UpdateTable",
  #     "dynamodb:CreateTable",
  #     "dynamodb:DeleteTable",
  #   ]

  #   resources = [
  #     "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dyanmodb_table_prefix}*",
  #   ]
  # }
}

data "aws_caller_identity" "current" {}

#
# Helm - ${local.name}
#
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    s3                    = aws_s3_bucket.loki-stack.bucket
    awsAccountID          = data.aws_caller_identity.current.account_id
    awsRegion             = var.aws_region
    clusterName           = var.cluster_name
    dyanmodb_table_prefix = var.dyanmodb_table_prefix
  }
}

module "loki" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.30"

  repository          = "https://grafana.github.io/helm-charts"
  official_chart_name = local.name
  user_chart_name     = local.name
  helm_version        = var.helm_chart_version
  namespace           = var.namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

  depends_on = [
    aws_s3_bucket.loki-stack, aws_iam_policy.loki-stack
  ]
}

data "template_file" "helm_values_promtail" {
  template = file("${path.module}/helm_values_promtail.tpl.yaml")
  vars = {
    # s3           = aws_s3_bucket.loki-stack.bucket
    # awsAccountID = data.aws_caller_identity.current.account_id
    # awsRegion    = var.aws_region
    # clusterName  = var.cluster_name
  }
}

module "promtail" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.30"

  repository          = "https://grafana.github.io/helm-charts"
  official_chart_name = local.name_promtail
  user_chart_name     = local.name_promtail
  helm_version        = var.helm_chart_version_promtail
  namespace           = var.namespace
  helm_values         = data.template_file.helm_values_promtail.rendered
  helm_values_2       = var.helm_values_2_promtail

  depends_on = [
    module.loki
  ]
}

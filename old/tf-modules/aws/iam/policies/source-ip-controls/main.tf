terraform {
  backend "s3" {}
}

data "aws_iam_policy_document" "policy-doc" {
  statement {

    effect = "Deny"
    actions = ["*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"

      values = var.source-ip-list
    }
  }
}

resource "aws_iam_policy" "policy" {
  name   = var.name
  description = var.description
  path   = var.path
  policy = data.aws_iam_policy_document.policy-doc.json
}

#
# The AWS Managed Prometheus service (AMP)
#
resource "aws_prometheus_workspace" "this" {
  alias = var.workspace_alias

  tags = var.tags
}

#
# The role that has access to the AMP this module creates
#
locals {
  base_name                = "aws-managed-prometheus"
  k8s_service_account_name = "aws-managed-prometheus"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "iam_assumable_role_admin" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "3.6.0"
  create_role = true
  role_name   = "${local.base_name}-${var.environment_name}"
  # role_path                     = "/token-file-web-identity/"
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.this.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.k8s_service_account_name}-${var.environment_name}"]
}

# Policy sourced from the AWS setup guide: https://docs.aws.amazon.com/prometheus/latest/userguide/set-up-irsa.html#set-up-irsa-ingest
data "template_file" "iam_policy" {
  template = file("${path.module}/iam-policy.tpl.json")
  vars = {
    awsAccountID  = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
    awsRegion     = data.aws_region.current.name
    secretsPrefix = var.secrets_prefix
    envName       = var.environment_name
  }
}

resource "aws_iam_policy" "this" {
  name_prefix = "${local.base_name}-${var.environment_name}"
  description = "${local.base_name} for ${var.environment_name}"
  policy      = data.template_file.iam_policy.rendered
}

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

resource "aws_iam_openid_connect_provider" "this" {
  count = length(var.iam_access_grant_list)

  url             = var.iam_access_grant_list[count.index].oidc_provider_url
  client_id_list  = var.iam_access_grant_list[count.index].oidc_provider_client_id_list
  thumbprint_list = var.iam_access_grant_list[count.index].oidc_provider_thumbprint_list
  tags            = merge(var.tags, {instance_name=var.iam_access_grant_list[count.index].instance_name, description=var.iam_access_grant_list[count.index].description})
}

module "iam_assumable_role_admin" {
  count       = length(var.iam_access_grant_list)
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "3.6.0"
  create_role = true
  role_name   = "${local.base_name}-${var.iam_access_grant_list[count.index].environment_name}"
  # role_path                     = "/token-file-web-identity/"
  aws_account_id                = data.aws_caller_identity.current.account_id
  provider_url                  = "oidc.eks.us-west-2.amazonaws.com/id/B4EA44BE30ABD91AC23C475F32379593"
  #replace(var.iam_access_grant_list[count.index].eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.this.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.iam_access_grant_list[count.index].namespace}:${local.k8s_service_account_name}-${var.iam_access_grant_list[count.index].environment_name}"]
  tags                          = merge(var.tags, {instance_name=var.iam_access_grant_list[count.index].instance_name, description=var.iam_access_grant_list[count.index].description})
}

# Policy sourced from the AWS setup guide: https://docs.aws.amazon.com/prometheus/latest/userguide/set-up-irsa.html#set-up-irsa-ingest
data "template_file" "iam_policy" {
  template = file("${path.module}/iam-policy.tpl.json")
  vars = {
    awsAccountID  = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
    awsRegion     = data.aws_region.current.name
    workspace_id  = aws_prometheus_workspace.this.id
  }
}

resource "aws_iam_policy" "this" {
  name_prefix = "${local.base_name}-${var.instance_name}"
  description = "${local.base_name} for ${var.instance_name}"
  policy      = data.template_file.iam_policy.rendered
  tags        = var.tags
}

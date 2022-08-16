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

  # The Statement[].Principal.Federated value in the AWS IAM Role's -> Trust Relationship
  # In this case we are going to set the principal to the OIDC provider we created above which is
  # the remote EKS cluster that we want to trust.
  # The replace is removing the duplicate arn info that this iam-assumable-role-with-oidc module concats
  # into the string when it forms this provider_url string
  provider_url                  = replace(aws_iam_openid_connect_provider.this[count.index].arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/", "")

  # The Statement[].Condition.StringEqual matching condition to match the EKS cluster ID, system:serviceaccount:<k8s namespace>:<k8s service account name>
  # The identity in the JWT's sub has this information in it which is cryptographically signed.  It would be very hard to reproduce this anywhere else
  # without owning this EKS cluster.
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.iam_access_grant_list[count.index].namespace}:${var.iam_access_grant_list[count.index].kube_service_account_name}"]
  
  # AWS IAM Policy to place onto this role
  role_policy_arns              = [aws_iam_policy.this.arn]

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

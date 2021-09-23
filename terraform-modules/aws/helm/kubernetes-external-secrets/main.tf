locals {
  base_name                = "kubernetes-external-secrets"
  iam_policy_file          = "iam-policy.tpl.json"
  k8s_service_account_name = "kubernetes-external-secrets"
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
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.k8s_service_account_name}-${var.environment_name}"]
}

data "template_file" "iam_policy" {
  template = file("${path.module}/iam-policy.tpl.json")
  vars = {
    awsAccountID  = data.aws_caller_identity.current.account_id
    awsRegion     = data.aws_region.current.name
    secretsPrefix = var.secrets_prefix
    envName       = var.environment_name
  }
}

# Policy doc: https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json
resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "${local.base_name}-${var.environment_name}"
  description = "${local.base_name} for ${var.environment_name}"
  policy      = data.template_file.iam_policy.rendered
}

#
# Helm templating
#
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    awsAccountID       = data.aws_caller_identity.current.account_id
    awsRegion          = data.aws_region.current.name
    serviceAccountName = local.k8s_service_account_name
    resource_name      = "${local.base_name}-${var.environment_name}"
  }
}

resource "helm_release" "helm_chart" {
  chart            = "kubernetes-external-secrets"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://external-secrets.github.io/kubernetes-external-secrets/"

  values = [
    data.template_file.helm_values.rendered,
    var.helm_values,
  ]

  depends_on = [
    module.iam_assumable_role_admin
  ]
}

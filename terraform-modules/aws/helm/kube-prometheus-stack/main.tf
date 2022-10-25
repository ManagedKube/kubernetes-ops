locals {
  base_name                = "kube-prometheus-stack"
  k8s_service_account_name = "kube-prometheus-stack-grafana"
}

resource "helm_release" "helm_chart" {
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://prometheus-community.github.io/helm-charts"

  values = [
    # templatefile("${path.module}/values.yaml", {
    templatefile("./values_local.yaml", {
      enable_grafana_aws_role = var.enable_iam_assumable_role_grafana
      aws_account_id          = var.aws_account_id
      role_name               = local.k8s_service_account_name
    }),
    var.helm_values,
  ]
}

############################
# An AWS assumable role for grafana
#
# Use case:
# * If you want to give Grafana IAM permission to query AWS Cloudwatch logs
#
############################
module "iam_assumable_role_grafana" {
  count                         = var.enable_iam_assumable_role_grafana ? 1 : 0
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = local.k8s_service_account_name
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.grafana[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.k8s_service_account_name}"]
  tags                          = var.tags
}

# Policy doc: https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json
resource "aws_iam_policy" "grafana" {
  count       = var.enable_iam_assumable_role_grafana ? 1 : 0
  name_prefix = "${local.base_name}-${var.environment_name}"
  description = "${local.base_name} for ${var.environment_name}"
  policy      = var.aws_policy_grafana
  tags        = var.tags
}

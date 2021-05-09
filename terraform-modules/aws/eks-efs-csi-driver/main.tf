module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "efs-csi-driver-${var.cluster_name}"
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
}

# Policy doc: https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json
resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "efs-csi-driver-${var.cluster_name}"
  description = "EKS efs-csi-driver policy for cluster ${var.eks_cluster_id}"
  policy      = file("${path.module}/efs-policy.json")
}

data "aws_caller_identity" "current" {}

#
# Helm - efs-csi-driver
#
# Docs: https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/charts/aws-efs-csi-driver
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    awsAccountID       = data.aws_caller_identity.current.account_id
    awsRegion          = var.aws_region
    clusterName        = var.cluster_name
    serviceAccountName = var.k8s_service_account_name
  }
}

module "eks-efs-csi-driver" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.9"

  repository          = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  official_chart_name = "aws-efs-csi-driver"
  user_chart_name     = "aws-efs-csi-driver"
  helm_version        = "1.2.4"
  namespace           = "kube-system"
  helm_values         = data.template_file.helm_values.rendered

  depends_on = [
    module.iam_assumable_role_admin
  ]
}

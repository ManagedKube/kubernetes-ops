module "ebs_csi" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.15.0"
  role_name                     = "EbsCsiDriver-${var.clustername}"
  role_path                     = "/eks/"
  create_role                   = true
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [var.ebs_driver_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "ebs_csi" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  chart      = "https://github.com/kubernetes-sigs/aws-ebs-csi-driver/releases/download/${var.ebs_chart_version}/helm-chart.tgz"

  values = [
    yamlencode({
      extraVolumeTags = {
        Clustername = var.clustername
        ManagedBy = "ebs-csi"
      }
      enableVolumeScheduling = true
      enableVolumeResizing = true
      enableVolumeSnapshot = true
      region = var.region

      serviceAccount = {
        controller = {
          annotations = {
            "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account_id}:role/eks/EbsCsiDriver-${var.clustername}"
          }
        }
      }
    })
  ]

  depends_on = [
    module.eks
  ]
}

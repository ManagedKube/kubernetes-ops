

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler-${var.cluster_name}"
  description = "EKS cluster-autoscaler policy for cluster ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

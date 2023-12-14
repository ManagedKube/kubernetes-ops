# MSK Policy
resource "aws_msk_cluster_policy" "cp" {
  cluster_arn = var.cluster_arn
  policy      = var.cluster_policy
}

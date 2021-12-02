module "eks-kube-state-metrics" {
  source  = "lablabs/eks-kube-state-metrics/aws"
  version = "0.8.0"
  helm_chart_version = var.helm_version
}


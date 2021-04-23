resource "helm_release" "helm_chart" {
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://argoproj.github.io/argo-helm"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}

resource "helm_release" "helm_chart" {
  chart            = "thanos"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://charts.bitnami.com/bitnami"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}
resource "helm_release" "helm_chart" {
  chart            = "kiali-operator"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://kiali.org/helm-charts"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}

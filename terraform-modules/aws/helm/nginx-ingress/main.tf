resource "helm_release" "helm_chart" {
  chart            = "ingress-nginx"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://kubernetes.github.io/ingress-nginx"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}

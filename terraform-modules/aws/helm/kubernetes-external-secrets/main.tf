resource "helm_release" "helm_chart" {
  chart            = "kubernetes-external-secrets"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://external-secrets.github.io/kubernetes-external-secrets/"

  values = [
    file("${path.module}/values.yaml"),
    var.helm_values,
  ]

}

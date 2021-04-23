resource "helm_release" "helm_chart" {
  chart            = var.official_chart_name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.user_chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = var.repository

  values = [
    var.helm_values,
  ]

}

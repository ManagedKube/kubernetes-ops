resource "helm_release" "helm_chart" {
  chart            = var.official_chart_name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.user_chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = var.repository
  repository_username = var.repository_username
  repository_password = var.repository_password

  values = [
    var.helm_values,
    var.helm_values_2,
  ]

}

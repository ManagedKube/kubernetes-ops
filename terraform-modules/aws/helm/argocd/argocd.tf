resource "helm_release" "argocd" {
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = "true"
  name             = var.chart_name
  version          = var.helm_version
  verify           = true
  repository       = "https://argoproj.github.io/argo-helm"

  values = [
    "${file("values.yaml")}"
  ]

}

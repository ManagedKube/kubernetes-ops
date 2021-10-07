resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace
  metadata {
    annotations = var.namespace_annotations

    labels = var.namespace_labels

    name = var.namespace_name
  }
}

resource "helm_release" "helm_chart_istio-base" {
  chart            = "./istio-${var.istio_version}/manifests/charts/base"
  namespace        = var.namespace_name
  create_namespace = false
  name             = var.istio_base_chart_name
  # version          = var.helm_version
  verify = var.verify

  values = [
    var.helm_values_istio_base,
  ]

  depends_on = [
    kubernetes_namespace.namespace
  ]
}

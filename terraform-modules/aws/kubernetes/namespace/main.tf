resource "kubernetes_namespace" "this" {
  metadata {
    annotations = var.annotations

    labels = var.labels

    name = var.name
  }
}

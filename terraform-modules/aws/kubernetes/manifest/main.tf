resource "kubernetes_manifest" "test-configmap" {
  manifest = yamldecode(var.manifest)
}

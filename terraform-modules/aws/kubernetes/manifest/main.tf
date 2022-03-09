resource "kubernetes_manifest" "manifest" {
  manifest = yamldecode(var.manifest)
}

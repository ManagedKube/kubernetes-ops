locals {
  base_name = "external-secrets"
}

resource "kubernetes_manifest" "external_secret" {
  manifest = yamldecode(var.yaml)
  computed_fields = ["spec.refreshInterval"]
}

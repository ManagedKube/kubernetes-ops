locals {
  base_name = "external-secrets"
}

data "aws_region" "current" {}

resource "kubernetes_manifest" "external_secret" {
  manifest = yamldecode(var.yaml)
}

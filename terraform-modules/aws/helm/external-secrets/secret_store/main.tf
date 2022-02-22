locals {
  base_name                = "external-secrets"
}

data "aws_region" "current" {}

resource "kubernetes_manifest" "secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1alpha1"
    "kind"       = "SecretStore"
    # "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name"      = var.secret_store_name
      "namespace" = var.namespace
      "labels"    = {
        "managed/by": "terraform"
      }
    }
    "spec" = {
      "provider" = {
        "aws": {
          "service": "SecretsManager"
          "region": data.aws_region.current.name
          "auth": {
            "jwt": {
              "serviceAccountRef": {
                "name": "${local.base_name}-${var.environment_name}"
              }
            }
          }
        }
      }
    }
  }
}

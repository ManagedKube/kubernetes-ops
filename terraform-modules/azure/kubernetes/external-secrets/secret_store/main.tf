locals {
  base_name                = "external-secrets"
  namespace_name = var.namespace
  ## This should match the name of the service account created by helm chart
  service_account_name = "${var.environment_name}-${local.namespace_name}"
}

################################################
## Setting up the Azure OIDC Federation
################################################

## Azure AD application that represents the app
resource "azuread_application" "app" {
  display_name = "${local.base_name}-${var.environment_name}"
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
}

## Azure AD federated identity used to federate kubernetes with Azure AD
resource "azuread_application_federated_identity_credential" "app" {
  application_object_id = azuread_application.app.object_id
  display_name          = "fed-identity-${local.base_name}-${var.environment_name}"
  description           = "The federated identity used to federate K8s with Azure AD with the app service running in k8s ${local.base_name} ${var.environment_name}"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = var.oidc_k8s_issuer_url
  subject               = "system:serviceaccount:${local.namespace_name}:${local.service_account_name}"
}

################################################
## Grant external-secrets deployment permissions to an Azure Vault
##
## The azuread_service_principal.app.object_id will be granted access
## Azure console -> vault -> <this vault instance -> Access Policies
## * should see "${local.base_name}-${var.environment_name}" in the list.
################################################
resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = var.azurerm_key_vault_id
  tenant_id    = var.azure_tenant_id
  object_id    = azuread_service_principal.app.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

################################################
## External-secrets k8s service account
################################################
resource "kubernetes_manifest" "k8s_service_account" {
  manifest = yamldecode(templatefile("yaml/service_account.yaml", {
    serviceAccountName = "secret-store-${local.base_name}-${var.environment_name}"
    # The Application ID (also called Client ID).
    client_id          = azuread_application.app.application_id
    tenant_id          = var.azure_tenant_id
  }))

  depends_on = [
    azuread_application.app
  ]
}

################################################
## External-secrets secret stores configurations
################################################

# resource "kubernetes_manifest" "secret_store" {
#   manifest = yamldecode(var.manifest)
#   # manifest = {
#   #   "apiVersion" = "external-secrets.io/v1alpha1"
#   #   "kind"       = "SecretStore"
#   #   "metadata" = {
#   #     "name"      = var.secret_store_name
#   #     "namespace" = var.namespace
#   #     "labels"    = {
#   #       "managed/by": "terraform"
#   #     }
#   #   }
#   #   "spec" = {
#   #     "provider" = {
#   #       "aws": {
#   #         "service": "SecretsManager"
#   #         "region": data.aws_region.current.name
#   #         "auth": {
#   #           "jwt": {
#   #             "serviceAccountRef": {
#   #               "name": "${local.base_name}-${var.environment_nameironment_name}"
#   #             }
#   #           }
#   #         }
#   #       }
#   #     }
#   #   }
#   # }
# }

resource "kubernetes_manifest" "cluster_secret_store" {
  manifest = yamldecode(templatefile("yaml/cluster_secret_store.yaml", {
    secret_store_name = var.secret_store_name
    vault_url         = var.vault_url
  }))
}


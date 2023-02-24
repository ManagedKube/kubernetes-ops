locals {
  base_name                = "external-secrets"
  namespace_name = var.namespace
  ## This should match the name of the service account created by helm chart
  service_account_name = "secret-store-${var.environment_name}-${local.namespace_name}"
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

  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  storage_permissions     = var.storage_permissions
}

################################################
## External-secrets k8s service account
################################################
## Need to use kubernetes_service_account instead of the kubernetes_manifest
## The kubernetes_manifest will try to parse out all of the fields
## on plan.  When it is trying to parse out azuread_application.app.application_id
## it does not exist yet on plan and will error out.  There is no way around
## the kubernetes_manifest limitations for now.  Using kubernetes_service_account
## gets around this problem by using the terraform resource which it will actually
## wait until that resource is created before trying to parse it (blah!).
resource "kubernetes_service_account" "this" {
  metadata {
    name = local.service_account_name
    namespace = local.namespace_name
    labels = {
      "azure.workload.identity/use" = "true"
      "created-by" = "terraform"
      "repo-source" = "kubernetes-ops"
    }
    annotations = {
      "azure.workload.identity/tenant-id" = var.azure_tenant_id
      "azure.workload.identity/client-id" = azuread_application.app.application_id
      "azure.workload.identity/service-account-token-expiration" = "86400"
    }
  }
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
    namespace_name          = local.namespace_name
    secret_store_name       = var.secret_store_name
    vault_url               = var.vault_url
    k8s_serviceaccount_name = local.service_account_name
  }))
}


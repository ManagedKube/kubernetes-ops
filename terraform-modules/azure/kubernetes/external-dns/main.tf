locals {
  helm_repository     = "https://kubernetes-sigs.github.io/external-dns/"
  official_chart_name = "external-dns"
  base_name           = "external-dns"
  ## This should match the name of the service account created by helm chart
  service_account_name = "${local.base_name}-${var.environment_name}-${var.k8s_namespace}"
}

data "azurerm_subscription" "current" {
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
  subject               = "system:serviceaccount:${var.k8s_namespace}:${local.service_account_name}"
}

## Role assignment to the application
## Doc: https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure.md#assign-the-rights-for-the-service-principal
## Access permissions
## Error: authorization.RoleAssignmentsClient#Create: Failure
## This most likely means you do not have the correct permissions to perform a role assignment
## Doc: https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
## This doc shows how to perform a role assignment and talks about checking the permission you have
## Your role might be a global admin but you also need the correct permissions for the Azure Subscription
## This doc shows you how to check what permissions you have for a subscription
## Check: Azure portal -> Subscriptions -> <the subscription in question> -> Settings -> My Permissions -> Go to subscription access control (IAM) -> Check Access -> View My access
## The "contributor" role is not enough.  Per the doc you need: Owner role or User Access Administrator role
##
## The assigned role external-dns needs:
## * https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure-private-dns.md#configure-service-principal-for-managing-the-zone
## * role name: "Private DNS Zone Contributor"
##
## Checking the role assignment:
## * Azure portal -> Azure DNS -> <the zone in question> -> Access Control (IAM) -> Role Assignment
## * The "external-dns-<env>" service principal should be in this list
##
resource "azurerm_role_assignment" "app_storage_contributor" {
  ## Scope to for assignment
  scope                = var.azure_dns_id
  ## The role name (pre-defined built in azure roles)
  ## Use the "role_definition_id" var to provide it with a custom role definition (see terraform doc for this resource for more informations)
  role_definition_name = var.role_definition_name
  ## The principal to assign it to
  principal_id         = azuread_service_principal.app.id
}

################################################
## Helm Chart install
################################################
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    # serviceAccountName = local.service_account_name
    client_id          = azuread_application.app.application_id
    tenant_id          = var.azure_tenant_id
    subscription_id    = data.azurerm_subscription.current.subscription_id
    azure_resource_group_name = var.azure_resource_group_name
  }
}

module "external-dns" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.27"

  repository          = local.helm_repository
  official_chart_name = local.official_chart_name
  user_chart_name     = var.user_chart_name
  helm_version        = var.helm_chart_version
  namespace           = var.k8s_namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

  depends_on = [
    azurerm_role_assignment.app_storage_contributor
  ]
}

################################################
## The `azure.json` configuration file
################################################
data "template_file" "azure_json_file" {
  template = file("${path.module}/azure.json")
  vars = {
    client_id                 = azuread_application.app.application_id
    tenant_id                 = var.azure_tenant_id
    azure_resource_group_name = var.azure_resource_group_name
    subscription_id           = data.azurerm_subscription.current.subscription_id
  }
}

## The `azure.json` configuration file
## Doc: https://github.com/kubernetes-sigs/external-dns/blob/91f912bc26f7012cedfce99bd608bc19e2b023dd/docs/tutorials/azure.md#configuration-file
resource "kubernetes_secret_v1" "example" {
  metadata {
    name        = "azure-config-file"
    namespace   = var.k8s_namespace
    annotations = {
      "created-by" = "kubernetes-ops"
    }
  }

  data = {
    "azure.json" = data.template_file.azure_json_file.rendered
  }
}

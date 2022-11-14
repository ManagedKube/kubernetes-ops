locals {
  base_name      = "external-secrets"
  namespace_name = var.namespace
  ## This should match the name of the service account created by helm chart
  service_account_name = "${var.env}-${local.namespace_name}"
}

################################################
## Setting up the Azure OIDC Federation
################################################

## Azure AD application that represents the app
resource "azuread_application" "app" {
  display_name = "sp-app-${var.env}"
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
  display_name          = "fed-identity-app-${var.env}"
  description           = "The federated identity used to federate K8s with Azure AD with the app service running in k8s ${var.env}"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = var.oidc_k8s_issuer_url
  subject               = "system:serviceaccount:${local.namespace_name}:${local.service_account_name}"
}

################################################
## Helm Chart install
################################################
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    serviceAccountName = local.service_account_name
    client_id          = azuread_application.app.application_id
    tenant_id          = var.azure_tenant_id
  }
}

resource "helm_release" "helm_chart" {
  chart            = "external-secrets"
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.chart_name
  version          = var.helm_version
  verify           = var.verify
  repository       = "https://charts.external-secrets.io"

  values = [
    data.template_file.helm_values.rendered,
    var.helm_values,
  ]

  depends_on = [
    azuread_application.app
  ]
}

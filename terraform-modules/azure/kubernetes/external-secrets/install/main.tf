locals {
  base_name      = "external-secrets"
}

################################################
## Helm Chart install
################################################
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    # serviceAccountName = local.service_account_name
    # client_id          = azuread_application.app.application_id
    # tenant_id          = var.azure_tenant_id
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

  # depends_on = [
  #   azuread_application.app
  # ]
}

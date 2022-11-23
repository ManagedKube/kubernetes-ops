locals {
  helm_repository     = "https://kubernetes-sigs.github.io/external-dns/"
  official_chart_name = "external-dns"
  base_name           = "external-dns"
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
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.27"

  repository          = local.helm_repository
  official_chart_name = local.official_chart_name
  user_chart_name     = var.user_chart_name
  helm_version        = var.helm_chart_version
  namespace           = var.k8s_namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

  # depends_on = [
  #   azuread_application.app
  # ]
}

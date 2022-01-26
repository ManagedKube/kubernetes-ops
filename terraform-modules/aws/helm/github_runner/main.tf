locals {
  helm_repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  official_chart_name = "actions-runner-controller"
}

#
# create namespace
#
module "namespace" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/kubernetes/namespace?ref=v1.0.50"
  
  name = var.k8s_namespace
}

#
# Helm values
#
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    ca_public_key = base64encode(module.cert.ca_public_key)
  }
}

module "helm_generic" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.27"

  repository          = local.helm_repository
  official_chart_name = local.official_chart_name
  user_chart_name     = var.user_chart_name
  helm_version        = var.helm_chart_version
  namespace           = var.k8s_namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

  depends_on = [
    module.cert,
    kubernetes_secret_v1.this,
    module.namespace,
  ]
}

#
# kubernetes-external-secret
#
# Using the Github PAT method
# doc: https://github.com/actions-runner-controller/actions-runner-controller#deploying-using-pat-authentication
# This is the secret referencing the PAT token in AWS Secret
resource "kubernetes_manifest" "kube_secret_crd" {
  count = var.enable_kubernetes_external_secret ? 1 : 0

  manifest = {
    apiVersion = "kubernetes-client.io/v1"
    kind       = "ExternalSecret"

    metadata = {
      name      = var.kubernetes_external_secret_name
      namespace = var.k8s_namespace
    }

    spec = {
      backendType = "secretsManager"

      data = [
          {
              # AWS Secrets name
              key  = var.aws_secret_name
              # The name in the k8s secret
              name = var.k8s_secret_key_name
          },
      ]
    }
  }

  depends_on = [
    module.namespace
  ]
}

#
# Generate self signed certs for use with the runner:
# doc: https://github.com/actions-runner-controller/actions-runner-controller#using-without-cert-manager
# Even the cert-manager is configured to generate a self signed cert
#
module "cert" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/generate-cert?ref=github-runner"
  
  ca_public_key_file_path = "/tmp/ca_public_key_file"
  public_key_file_path    = "/tmp/public_key_file"
  private_key_file_path   = "/tmp/private_key_file"
  owner                   = "k8s"
  ca_common_name          = "k8s"
  common_name             = "k8s"
  ip_addresses            = []
  validity_period_hours   = 43830
  organization_name       = "k8s"

  dns_names = [
    "webhook-service.${var.k8s_namespace}.svc",
    "webhook-service.${var.k8s_namespace}.svc.cluster.local",
  ]
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    name = "actions-runner-controller-serving-cert"
    # name = "webhook-server-cert"
    namespace = var.k8s_namespace
  }

  data = {
    "tls.crt" = module.cert.client_cert
    "tls.key" = module.cert.client_private_key
  }

  type = "kubernetes.io/tls"

  depends_on = [
    module.cert,
    module.namespace,
  ]
}

resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace
  metadata {
    annotations = var.namespace_annotations

    labels = var.namespace_labels

    name = var.namespace_name
  }
}

resource "helm_release" "helm_chart_istio_base" {
  count            = var.install_helm_chart_istio_base
  chart            = "${path.module}/istio-${var.istio_version}/manifests/charts/base"
  namespace        = var.namespace_name
  create_namespace = false
  name             = var.istio_base_chart_name
  verify           = var.verify

  values = [
    var.helm_values_istio_base,
  ]

  depends_on = [
    kubernetes_namespace.namespace
  ]
}

resource "helm_release" "helm_chart_istio_discovery" {
  count            = var.install_helm_chart_istio_discovery
  chart            = "${path.module}/istio-${var.istio_version}/manifests/charts/istio-control/istio-discovery"
  namespace        = var.namespace_name
  create_namespace = false
  name             = var.istio_discovery_chart_name
  verify           = var.verify

  values = [
    var.helm_values_istiod,
  ]

  depends_on = [
    helm_release.helm_chart_istio_base
  ]
}

data "template_file" "helm_chart_istio_ingress" {
  template = file("${path.module}/values/istio_ingress_values.tpl.yaml")

  vars = {
    acmARN      = module.acm_request_certificate[0].arn
  }
}

resource "helm_release" "helm_chart_istio_ingress" {
  count            = var.install_helm_chart_istio_ingress
  chart            = "${path.module}/istio-${var.istio_version}/manifests/charts/gateways/istio-ingress"
  namespace        = var.namespace_name
  create_namespace = false
  name             = var.istio_ingress_chart_name
  verify           = var.verify

  values = [
    data.template_file.helm_chart_istio_ingress.rendered,
    var.helm_values_istio_ingress,
  ]

  depends_on = [
    helm_release.helm_chart_istio_base
  ]
}

resource "helm_release" "helm_chart_istio_egress" {
  count            = var.install_helm_chart_istio_egress
  chart            = "${path.module}/istio-${var.istio_version}/manifests/charts/gateways/istio-egress"
  namespace        = var.namespace_name
  create_namespace = false
  name             = var.istio_egress_chart_name
  verify           = var.verify

  values = [
    var.helm_values_istio_egress,
  ]

  depends_on = [
    helm_release.helm_chart_istio_base
  ]
}

module "acm_request_certificate" {
  source = "cloudposse/acm-request-certificate/aws"
  version = "0.16.0"

  count = var.create_acm_cert ? 1 : 0

  domain_name                       = var.acm_domain_name
  process_domain_validation_options = true
  ttl                               = var.acm_ttl
  subject_alternative_names         = var.acm_subject_alternative_names
}

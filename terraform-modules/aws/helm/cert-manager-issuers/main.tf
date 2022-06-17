locals {
  official_chart_name = "cert-manager"
}

data "aws_caller_identity" "current" {}

#############################
# cert-manager DNS01 cluster-issuer
# https://cert-manager.io/docs/configuration/acme/dns01/route53/#creating-an-issuer-or-clusterissuer
#############################
# file templating
data "template_file" "dns01_cluster_issuer_yaml" {
  template = file("${path.module}/dns01-cluster-issuer.tpl.yaml")

  vars = {
    awsRegion           = var.aws_region
    letsEncryptServer   = var.lets_encrypt_server
    emailAddress        = var.lets_encrypt_email
    dnsZhostedZoneIDone = var.route53_hosted_zones
    domainName          = var.domain_name
    awsAccountID        = data.aws_caller_identity.current.account_id
    clusterName         = var.cluster_name
    chartName           = local.official_chart_name
  }
}

resource "kubernetes_manifest" "dns01_cluster_issuer" {
  count    = var.enable_dns01_cluster_issuer
  manifest = yamldecode(data.template_file.dns01_cluster_issuer_yaml.rendered)
}

#############################
# cert-manager HTTP01 cluster-issuer
# https://cert-manager.io/docs/configuration/acme/http01/#configuring-the-http01-ingress-solver
#############################
# file templating
data "template_file" "http01_cluster_issuer_yaml" {
  template = file("${path.module}/http01-cluster-issuer.tpl.yaml")

  vars = {
    emailAddress      = var.lets_encrypt_email
    letsEncryptServer = var.lets_encrypt_server
    ingressClass      = var.ingress_class
  }
}

resource "kubernetes_manifest" "http01_cluster_issuer" {
  count    = var.enable_http01_cluster_issuer
  manifest = yamldecode(data.template_file.http01_cluster_issuer_yaml.rendered)
}

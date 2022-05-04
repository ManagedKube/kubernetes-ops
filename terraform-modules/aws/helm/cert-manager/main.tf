locals {
  helm_repository     = "https://charts.jetstack.io"
  official_chart_name = "cert-manager"
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "${local.official_chart_name}-${var.cluster_name}"
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.iam_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.k8s_namespace}:${local.official_chart_name}"]
}

resource "aws_iam_policy" "iam_policy" {
  name_prefix = "${local.official_chart_name}-${var.cluster_name}"
  description = "EKS ${local.official_chart_name} policy for cluster ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.iam_policy_document.json
}

# IAM Role policy doc: https://cert-manager.io/docs/configuration/acme/dns01/route53/#set-up-an-iam-role
data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "route53:GetChange",
    ]

    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${var.route53_hosted_zones}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZonesByName",
    ]

    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}

#
# Helm values
#
data "template_file" "helm_values" {
  template = file("${path.module}/helm_values.tpl.yaml")
  vars = {
    awsAccountID       = data.aws_caller_identity.current.account_id
    clusterName        = var.cluster_name
    serviceAccountName = local.official_chart_name
    chartName          = local.official_chart_name
  }
}

module "cert-manager" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/helm/helm_generic?ref=v1.0.27"

  repository          = local.helm_repository
  official_chart_name = local.official_chart_name
  user_chart_name     = var.user_chart_name
  helm_version        = var.helm_chart_version
  namespace           = var.k8s_namespace
  helm_values         = data.template_file.helm_values.rendered
  helm_values_2       = var.helm_values_2

  depends_on = [
    module.iam_assumable_role_admin
  ]
}

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

resource "kubectl_manifest" "dns01_cluster_issuer" {
  count     = var.enable_dns01_cluster_issuer
  yaml_body = data.template_file.dns01_cluster_issuer_yaml.rendered

  depends_on = [
    module.cert-manager
  ]
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

resource "kubectl_manifest" "http01_cluster_issuer" {
  count     = var.enable_http01_cluster_issuer
  yaml_body = data.template_file.http01_cluster_issuer_yaml.rendered

  depends_on = [
    module.cert-manager
  ]
}
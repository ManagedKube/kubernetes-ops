data "aws_eks_cluster_auth" "main" {
  name = var.cluster_name
}

provider "kubectl" {
  host                   = var.kubernetes_api_host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.main.token
  load_config_file       = false
}

# file templating
data "template_file" "gateway" {
  template = file("${path.module}/gateway.tpl.yaml")

  vars = {
    namespace  = var.namespace
    gateway_hosts =  "${jsonencode(var.gateway_hosts)}"
    gateway_credentialName = var.gateway_credentialName
  }
}

resource "kubectl_manifest" "gateway" {
  yaml_body = data.template_file.gateway.rendered
}

# file templating
data "template_file" "certificate" {
  count    = var.enable_certificate ? 1 : 0
  template = file("${path.module}/certificate.tpl.yaml")

  vars = {
    namespace  = var.namespace
    cert_common_name = var.cert_common_name
    cert_dns_name = var.cert_dns_name
    issue_ref_name = var.issue_ref_name
    issue_ref_name = var.issue_ref_name
    issue_ref_kind = var.issue_ref_kind
    issue_ref_group = var.issue_ref_group
  }
}

resource "kubectl_manifest" "certificate" {
  count     = var.enable_certificate ? 1 : 0
  yaml_body = data.template_file.certificate[0].rendered
}

data "template_file" "ghcr_secret" {
  template = file("${path.module}/ghcr-secret.tpl.yaml")

  vars = {
    ghcr_secret = var.ghcr_secret
    namespace   = var.namespace
  }
}

resource "kubectl_manifest" "ghcr_secret" {
  yaml_body = data.template_file.ghcr_secret.rendered
}
data "local_file" "cert"{
    filename = var.cert_bundle
}

resource "aws_rolesanywhere_trust_anchor" "trust_anchor" {
    count = var.enable_trust_anchor ? 1:0
    name    = var.trust_anchor_name
    enabled = var.enable_trust_anchor
    source {
      source_data {
          x509_certificate_data  = data.local_file.cert.content
      }
      source_type = "CERTIFICATE_BUNDLE"
    }
    tags = var.tags

}

resource "aws_rolesanywhere_profile" "profile" {
    for_each =  var.profiles
    name = each.key
    enabled   = var.enable_profile
    role_arns = each.value.role_arns
    tags = var.tags
}

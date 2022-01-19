resource "aws_kms_key" "this" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy                   = var.kms_key_policy

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = format("%s/%s", "alias", var.kms_alias)
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = var.tags
}

resource "aws_route53_key_signing_key" "this" {
  hosted_zone_id             = aws_route53_zone.this.id
  key_management_service_arn = aws_kms_key.this.arn
  name                       = "key"
}

resource "aws_route53_hosted_zone_dnssec" "this" {
  depends_on = [
    aws_route53_key_signing_key.this
  ]
  hosted_zone_id = aws_route53_key_signing_key.this.hosted_zone_id
}

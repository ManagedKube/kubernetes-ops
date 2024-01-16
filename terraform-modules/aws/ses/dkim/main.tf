resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}
resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}
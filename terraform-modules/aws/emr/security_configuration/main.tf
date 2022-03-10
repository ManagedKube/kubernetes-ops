resource "aws_emr_security_configuration" "this" {
  name = var.name

  configuration = var.configuration
}

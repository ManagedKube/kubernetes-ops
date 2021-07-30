terraform {
  backend "s3" {
  }
}

resource "aws_ssm_document" "ssm_document" {
  name          = var.document_name
  document_type = var.document_type

  content = var.document_content

  tags = var.tags

}

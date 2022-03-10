resource "aws_athena_database" "this" {
  name   = var.name
  bucket = var.s3_bucket_name

  encryption_configuration {
      encryption_option = var.encryption_option
      kms_key           = var.kms_key
  }
}

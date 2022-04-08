module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.0.1"

  bucket = var.bucket
  acl    = var.acl

  versioning = var.versioning
}
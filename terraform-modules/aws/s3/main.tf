module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.0.1"

  bucket = var.bucket
  acl    = var.acl
  versioning = var.versioning
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  lifecycle_rule = var.lifecycle_rule
}
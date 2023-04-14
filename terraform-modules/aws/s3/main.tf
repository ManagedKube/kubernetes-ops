module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.8.2"
  bucket = var.bucket
  attach_policy= var.attach_policy
  policy = var.bucket_policy
  acl    = var.acl
  versioning = var.versioning
  block_public_acls = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls = var.ignore_public_acls
  lifecycle_rule = var.lifecycle_rule
}
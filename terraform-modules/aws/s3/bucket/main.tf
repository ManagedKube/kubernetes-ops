resource "aws_kms_key" "kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.deletion_window_in_days

  enable_key_rotation = var.enable_key_rotation

  tags = var.tags
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "acl" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = var.policy
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = var.enable_versioning ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count = var.enable_logging ? 1 : 0

  # Bucket to enable logging on
  bucket = aws_s3_bucket.bucket.id

  # (Required) The name of the bucket where you want Amazon S3 to store server access logs.
  target_bucket = var.logging_bucket_name
  target_prefix = "log/"
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  count = var.enable_bucket_owner_enforced ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = var.bucket_ownership_controls_rule
  }
}
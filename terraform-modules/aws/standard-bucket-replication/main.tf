locals {
  has_bucket_public_access_block = (var.block_public_acls || var.block_public_policy || var.ignore_public_acls || var.restrict_public_buckets) ? 1 : 0
}

terraform {
  # This module is now only being tested with Terraform 0.13.3. test edit
  required_version = ">= 0.13.3"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  profile = var.replica_provider_profile
  region  = var.replica_region

  alias = "replica"
}

module "bucket-tags" {
  source = "../../tags"

  env    = var.env
  group  = var.group
  name   = var.bucket_name
  region = var.region
}

# Single bucket usage.  No replication enabled.
module "terraform-aws-s3-bucket-single-bucket" {
  source        = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v2.6.0"
  count         = var.enable_replication == 1 ? 0 : 1
  bucket        = var.bucket_name
  tags          = module.bucket-tags.tags
  acl           = var.acl
  policy        = var.policy
  attach_policy = var.attach_policy
  cors_rule     = var.cors_rule

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  versioning = {
    enabled = var.versioning
  }

  lifecycle_rule = var.lifecycle_rules

}

resource "aws_s3_bucket_public_access_block" "single-bucket" {
  count                   = local.has_bucket_public_access_block
  bucket                  = module.terraform-aws-s3-bucket-single-bucket[0].s3_bucket_id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

module "terraform-aws-s3-bucket-source-replica" {
  source        = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v2.6.0"
  count         = var.enable_replication
  bucket        = var.bucket_name
  tags          = module.bucket-tags.tags
  acl           = var.acl
  policy        = var.policy
  attach_policy = var.attach_policy
  cors_rule     = var.cors_rule

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  versioning = {
    enabled = true
  }

  lifecycle_rule = var.lifecycle_rules

  replication_configuration = {
    role = aws_iam_role.replication[0].arn

    rules = [
      {
        id       = "replicate_1"
        status   = "Enabled"
        priority = 10

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket             = "arn:aws:s3:::${var.replica_bucket_name}"
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica[0].arn
          account_id         = data.aws_caller_identity.current.account_id
          access_control_translation = {
            owner = "Destination"
          }
        }
      }

    ]
  }

  depends_on = [
    module.terraform-aws-s3-bucket-replica,
  ]
}

resource "aws_s3_bucket_public_access_block" "source-replica" {
  count                   = local.has_bucket_public_access_block
  bucket                  = module.terraform-aws-s3-bucket-source-replica[0].s3_bucket_id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


module "terraform-aws-s3-bucket-replica" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v2.6.0"
  count  = var.enable_replication

  providers = {
    aws = aws.replica
  }

  bucket        = var.replica_bucket_name
  tags          = module.bucket-tags.tags
  acl           = var.acl
  policy        = var.policy_replica
  attach_policy = var.attach_policy
  cors_rule     = var.cors_rule

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  versioning = {
    enabled = true
  }

  lifecycle_rule = var.lifecycle_rules

}

resource "aws_s3_bucket_public_access_block" "replica" {
  count                   = local.has_bucket_public_access_block
  bucket                  = module.terraform-aws-s3-bucket-replica[0].s3_bucket_id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_kms_key" "replica" {
  count    = var.enable_replication
  provider = aws.replica

  description             = "S3 bucket replication KMS key"
  deletion_window_in_days = 7
}

# Permissions needed: https://docs.aws.amazon.com/AmazonS3/latest/userguide/setting-repl-config-perm-overview.html#setting-repl-config-same-acctowner
resource "aws_iam_role" "replication" {
  count = var.enable_replication
  name  = var.bucket_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = var.bucket_name

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["s3:ListBucket",
            "s3:GetReplicationConfiguration",
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging",
            "s3:GetObjectRetention",
            "s3:GetObjectLegalHold"
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::${var.bucket_name}",
            "arn:aws:s3:::${var.bucket_name}/*",
            "arn:aws:s3:::${var.replica_bucket_name}",
            "arn:aws:s3:::${var.replica_bucket_name}/*"
          ]
        },
        {
          Action = [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags",
            "s3:ObjectOwnerOverrideToBucketOwner"
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::${var.bucket_name}/*",
            "arn:aws:s3:::${var.replica_bucket_name}/*"
          ]
        },
      ]
    })
  }

  tags = module.bucket-tags.tags
}

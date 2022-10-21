locals {
  bucket_name = "test-test-1234-test-test-1234"
  env = "dev"
  region = "us-east-1"
  group = "devops"
}

module "bucket-with-replication" {
  source = "../.."

  bucket_name = local.bucket_name
  env         = local.env
  region      = local.region
  group       = local.group
  lifecycle_rules = [
    {
      enabled = true
      expiration = {
        days = 90
      }
    }
  ]

  # Replication settings
  replica_provider_profile = "qadium-dev"
  enable_replication = 1
  replica_region = "us-west-2"
  replica_bucket_name = "${local.bucket_name}-replica"
  policy_replica = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "githubBackup",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${local.bucket_name}-replica"
        },
        {
            "Sid": "githubBackupAccess",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${local.bucket_name}-replica/*"
        }
    ]
}
EOT
}
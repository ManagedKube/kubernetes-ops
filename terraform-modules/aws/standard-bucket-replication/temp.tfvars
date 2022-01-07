env = "gar-test"
region = "us-east-1"
group = "devops"
versioning = true
lifecycle_rules = [
  {
    enabled = true
    expiration = {
      days = 7
    }
  }
]

cors_rule = [
  {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://internal-tool.expander.dev.q-internal.tech"]
  }
]

block_public_acls = true

bucket_name = "garland-gar-123-source"
policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::garland-gar-123-source"
        },
        {
            "Sid": "ReadWriteAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::garland-gar-123-source/*"
        }
    ]
}
EOT

attach_policy = true
enable_replication = 1
replica_region = "us-west-2"
replica_bucket_name = "garland-gar-123-replica"
policy_replica = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::garland-gar-123-replica"
        },
        {
            "Sid": "ReadWriteAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::garland-gar-123-replica/*"
        }
    ]
}
EOT

replica_provider_profile = "qadium-dev"

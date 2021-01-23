include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.q-internal.tech/qadium/terraform-modules.git//s3?ref=v1.14.12"

}

inputs = {

  region      = "us-east-1"
  bucket_name = "managedkube-ssm-session-logs-dev"
  versioning  = "false"

  tags = {
    ops-environment     = "development"
    ops-tier            = "infrastructure"
    ops-subsystem       = "supporting-infrastructure"
    ops-owner           = "engineering"
    ops-name            = "ssm-session-interactive-session-logs"
    ops-tag-method      = "terraform"
    ops-tag-source-repo = "qadium/terraform"
    ops-tag-source-path = "aws/dev/ssm/s3_bucket_interactive_session_logs/terragrunt.hcl"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "AccessLogs-Policy-managedkube-ssm-session-logs-dev",
    "Statement": [
        {
            "Sid": "Terraform-managedkube-ssm-session-logs-dev-root-perms",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::127311923021:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::managedkube-ssm-session-logs-dev/*"
        },
        {
            "Sid": "Terraform-managedkube-ssm-session-logs-dev-AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::managedkube-ssm-session-logs-dev/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::managedkube-ssm-session-logs-dev"
        }
    ]
}
POLICY
}

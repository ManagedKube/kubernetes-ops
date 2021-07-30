include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.q-internal.tech/qadium/terraform-modules.git//aws/ssm/ec2-role/?ref=v1.14.12"

}

inputs = {
  region = "us-east-1"

  name = "GroupDev"

  s3_bucket_name = "managedkube-ssm-session-logs-dev"
  s3_bucket_prefix = "dev"

  tags = {
    ops-environment     = "development"
    ops-tier            = "infrastructure"
    ops-subsystem       = "supporting-infrastructure"
    ops-owner           = "engineering"
    ops-name            = "ssm-ec2-instance-role"
    ops-tag-method      = "terraform"
    ops-tag-source-repo = "qadium/terraform"
    ops-tag-source-path = "aws/dev/ssm/role/terragrunt.hcl"
  }
}

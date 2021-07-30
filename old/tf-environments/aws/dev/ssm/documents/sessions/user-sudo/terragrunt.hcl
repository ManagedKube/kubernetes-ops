include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@github.q-internal.tech/qadium/terraform-modules.git//aws/ssm/documents/sessions?ref=v1.14.12"

}

inputs = {

  document_name = "SSM-sudo"

  document_content = <<DOC
  {
  "schemaVersion": "1.0",
  "description": "Document to hold regional settings for Session Manager",
  "sessionType": "Standard_Stream",
  "inputs": {
    "s3BucketName": "managedkube-ssm-session-logs-dev",
    "s3KeyPrefix": "dev",
    "s3EncryptionEnabled": false,
    "cloudWatchLogGroupName": "",
    "cloudWatchEncryptionEnabled": true,
    "kmsKeyId": "",
    "runAsEnabled": true,
    "runAsDefaultUser": "user-sudo"
  }
}
DOC

  tags = {
    ops-environment     = "development"
    ops-tier            = "infrastructure"
    ops-subsystem       = "supporting-infrastructure"
    ops-owner           = "engineering"
    ops-name            = "ssm-session-user-sudo-dev"
    ops-tag-method      = "terraform"
    ops-tag-source-repo = "qadium/terraform"
    ops-tag-source-path = "aws/dev/ssm/documents/sessions/user-sudo/terragrunt.hcl"
  }
}

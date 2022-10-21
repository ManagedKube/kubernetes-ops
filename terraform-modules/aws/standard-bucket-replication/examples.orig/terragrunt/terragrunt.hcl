include {
  path = find_in_parent_folders()
}

// replace <VersionNumber> with appropriate shared-terraform-modules tag number
terraform {
  source = "git::ssh://git@github.q-internal.tech/qadium/shared-terraform-modules.git//aws/s3/standard-bucket?ref=v<VersionNumber>"
}

inputs = {
  bucket_name = "expanse-benchmark-reports-staging"
  region      = "us-west-2"
  env         = "prod"
  group       = "engineering"
  cors_rule   = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET"]
      allowed_origins = ["https://internal-tool.expander.staging.qadium.com"]
    }
  ]
}

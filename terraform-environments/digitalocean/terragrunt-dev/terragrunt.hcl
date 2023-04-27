locals {
  # Load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "skip"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_vars.locals.aws_region}"
}
EOF
}


remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-${get_aws_account_id()}-${local.region_vars.locals.aws_region}-${local.common_vars.locals.environment_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region_vars.locals.aws_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

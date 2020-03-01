remote_state {
  backend = "s3"
  config = {
    bucket = "kubernetes-ops-tf-state-${get_aws_account_id()}-terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "kubernetes-ops-lock-table"
  }
}

terraform {
  // extra_arguments "common_vars" {
  //   commands = get_terraform_commands_that_need_vars()
  //
  //   arguments = [
  //     "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/gcp.tfvars",
  //   ]
  // }
}

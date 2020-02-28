remote_state {
  backend = "gcs"
  config = {
    bucket = "kubernetes-ops-terraform-state-${get_env("STATE_STORE_UNIQUE_KEY", "default-value-1234")}"
    prefix  = path_relative_to_include()
    project = "managedkube"
    location = "us-central1"
  }
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

     arguments = [
      #  "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/gcp.tfvars",
      # "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
      "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
     ]
  }
}

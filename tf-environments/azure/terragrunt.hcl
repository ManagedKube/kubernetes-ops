remote_state {
    backend = "azurerm"
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        resource_group_name = "kubernetes-ops"
        storage_account_name = "kubernetesops"
        container_name = "tfstate"
    }
}

# terraform {
#   extra_arguments "common_vars" {
#     commands = get_terraform_commands_that_need_vars()

#      arguments = [
#       #  "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/gcp.tfvars",
#       # "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
#       "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
#      ]
#   }
# }

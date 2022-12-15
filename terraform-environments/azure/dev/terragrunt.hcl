locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

remote_state {
    backend = "azurerm"
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        key = "${path_relative_to_include()}/terraform.tfstate"
        ## Default kubernetes-ops instructions sets this value to: kubernetes-ops-dev
        resource_group_name = local.environment_vars.locals.azure_resource_group_name
        ## Default kubernetes-ops instructions sets this value to: kubernetesops
        storage_account_name = "kubernetesops"
        container_name = "tfstate"
    }
}

# Azure provider block that is common to all
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

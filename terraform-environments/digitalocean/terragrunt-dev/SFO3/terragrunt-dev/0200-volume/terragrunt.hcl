# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/digitalocean/volume?ref=digitalocean-kube-ops"
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../050-project"
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Load common variables shared across all accounts
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # Load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
    volume_name = "vol-${local.environment_vars.locals.project_name}"
    volume_region = local.region_vars.locals.digitalocean_region
    volume_description = "Volumen of ${local.environment_vars.locals.project_name} in region: ${local.region_vars.locals.digitalocean_region}"
    volume_initial_filesystem_type = "xfs"
    volume_project_id = dependency.project.outputs.project_id
}
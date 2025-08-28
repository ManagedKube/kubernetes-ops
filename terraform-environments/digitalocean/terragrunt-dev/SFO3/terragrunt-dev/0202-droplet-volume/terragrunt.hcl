# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/digitalocean/droplet_volume?ref=digitalocean-kube-ops"
}

dependency "volume" {
  config_path = "${get_terragrunt_dir()}/../0200-volume"
}

dependency "droplet" {
  config_path = "${get_terragrunt_dir()}/../0201-droplet"
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

  # Project name
  project_name = local.environment_vars.locals.project_name

  # Region name
  region_name=local.region_vars.locals.digitalocean_region 
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
    droplet_id =  dependency.droplet.outputs.droplet_id
    volume_id  =  dependency.volume.outputs.volume_id
}
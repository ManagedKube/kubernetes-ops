# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/digitalocean/droplet?ref=digitalocean-kube-ops"
}

dependency "project" {
  config_path = "${get_terragrunt_dir()}/../050-project"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../0100-vpc"
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
    droplet_name = "drop-${local.project_name}"
    droplet_image = "ubuntu-18-04-x64"
    droplet_monitoring = true
    droplet_region = "${local.region_name}"
    droplet_size = "s-1vcpu-1gb"
    droplet_user_data = ""
    droplet_vpc_uuid = dependency.vpc.outputs.vpc_id
    droplet_project_id = dependency.project.outputs.project_id
}
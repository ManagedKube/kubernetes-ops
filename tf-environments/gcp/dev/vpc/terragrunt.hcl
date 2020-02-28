include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/vpc/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

     arguments = [
      "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
     ]
  }
}

inputs = {
  vpc_name = "dev"

  public_subnet_cidr_range = "10.32.1.0/24"
  private_subnet_cidr_range = "10.32.5.0/24"

  outbound_through_nat_tags=["private-subnet", "gke-private-nodes"]
}

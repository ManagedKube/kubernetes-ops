include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../tf-modules/gcp/gke-subnets/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

     arguments = [
      "-var-file=${get_terragrunt_dir()}/../_env_defaults/gcp.tfvars",
     ]
  }
}

inputs = {
  vpc_name = trimspace(run_cmd("terragrunt", "output", "network_name", "--terragrunt-working-dir", "../vpc"))
  region = trimspace(run_cmd("terragrunt", "output", "region", "--terragrunt-working-dir", "../vpc"))
  network_name = trimspace(run_cmd("terragrunt", "output", "network_name", "--terragrunt-working-dir", "../vpc"))

  services_ip_cidr_range="10.32.64.0/19"
  pods_ip_cidr_range="10.36.0.0/14"    # 1024 max nodes

  #####################
  # networking
  #####################
  public_subnet_cidr_range = "10.32.16.0/20"
  private_subnet_cidr_range = "10.32.32.0/20"

}

dependencies {
  paths = ["../vpc"]
}

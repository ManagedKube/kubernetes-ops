include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../tf-modules/aws/networks/add-tg-routes/"

  # This module uses AWS keys from the local shell's environment

  # extra_arguments "common_vars" {
  #   commands = get_terraform_commands_that_need_vars()

  #   arguments = [
  #     "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/transit-gateway.tfvars",
  #   ]
  # }
}

inputs = {

  aws_region = "us-west-2"

  transit-gateway-id = trimspace(run_cmd("terragrunt", "output", "aws_ec2_transit_gateway_id", "--terragrunt-working-dir", "../../transit-gateway"))

  # Routing table associated with the VPC subnets
  route_table_id_list = ["rtb-09efef60458f61005", "rtb-0ab2a8c517e45a5e4"]

  # External destination routes list CIDR
  routes-list = ["10.35.0.0/16", "10.36.0.0/16", "10.38.0.0/16", "172.17.0.0/16"]

}

dependencies {
  paths = ["../../transit-gateway"]
}

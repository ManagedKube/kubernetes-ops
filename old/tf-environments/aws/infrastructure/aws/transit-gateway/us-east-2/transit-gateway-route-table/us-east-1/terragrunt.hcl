include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../../tf-modules/aws/networks/transit-gateway-route-table/"

  # This module uses AWS keys from the local shell's environment

  # extra_arguments "common_vars" {
  #   commands = get_terraform_commands_that_need_vars()

  #   arguments = [
  #     "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/transit-gateway.tfvars",
  #   ]
  # }
}

inputs = {

  aws_region = "us-east-2"

  destination_cidr_block_list = ["10.35.0.0/16", "10.37.0.0/16", "10.38.0.0/16"]

  blackhole_list = ["false", "false", "false"]

  # This is hardcoded right now b/c the transit-gateway to transit-gateway peering has to be done manually.  Terraform has a PR open for this functionality but it has not landed yet.
  transit_gateway_attachment_id = "tgw-attach-07ff6a0a0ca3ced71"

  transit_gateway_route_table_id = trimspace(run_cmd("terragrunt", "output", "aws_ec2_transit_gateway_propagation_default_route_table_id", "--terragrunt-working-dir", "../../transit-gateway"))

}

dependencies {
  paths = ["../../transit-gateway"]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../tf-modules/aws/networks/add-tg-routes/"

  # extra_arguments "common_vars" {
  #   commands = get_terraform_commands_that_need_vars()

  #   arguments = [
  #     "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/transit-gateway.tfvars",
  #   ]
  # }
}

inputs = {

  aws_region = "us-east-1"

  transit-gateway-id = trimspace(run_cmd("terragrunt", "output", "aws_ec2_transit_gateway_id", "--terragrunt-working-dir", "../../transit-gateway"))

  # Routing table associated with the VPC subnets
  route_table_id_list = ["rtb-0137cd69ffeeea89d", "rtb-0a568e7960813d48f"]

  # External destination routes list CIDR
  routes-list = ["10.36.0.0/16", "10.37.0.0/16"]
}

dependencies {
  paths = ["../transit-gateway"]
}

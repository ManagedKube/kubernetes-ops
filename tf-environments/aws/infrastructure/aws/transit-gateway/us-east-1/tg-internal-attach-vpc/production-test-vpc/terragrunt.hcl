include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../../tf-modules/aws/networks/tg-internal-attach-to-vpc/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/transit-gateway.tfvars",
    ]
  }
}

inputs = {

  aws_region = "us-east-1"

  name-postfix = "production-test-vpc"

  tags = {
    Environment     = "production-test-vpc",
    Account         = "infrastructure",
    Group           = "devops",
    Region          = "us-east-1"
    managed_by      = "Terraform"
    purpose         = "transit-gateway"
    terraform_module = "tg-internal-attach-to-vpc"
    terragrunt_dir = get_terragrunt_dir()
    last_callers_identity = get_aws_caller_identity_arn()
    last_callers_user_id  = get_aws_caller_identity_user_id()
  }

  transit-gateway-arn = trimspace(run_cmd("terragrunt", "output", "aws_ec2_transit_gateway_arn", "--terragrunt-working-dir", "../../transit-gateway"))
  transit-gateway-id = trimspace(run_cmd("terragrunt", "output", "aws_ec2_transit_gateway_id", "--terragrunt-working-dir", "../../transit-gateway"))

  vpc_id_first = trimspace(run_cmd("terragrunt", "output", "aws_vpc_id", "--terragrunt-working-dir", "../../vpc/production-test-vpc"))

  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  subnets_cidr = ["10.35.20.0/24", "10.35.21.0/24", "10.35.22.0/24"]
}

dependencies {
  paths = ["../../transit-gateway", "../../vpc/production-test-vpc"]
}

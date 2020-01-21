include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../tf-modules/aws/networks/tg-external-attach-to-vpc/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/_env_defaults/transit-gateway.tfvars",
      # "-var-file=../../vpc/dev-us/vpc-tfvars",
    ]
  }
}

locals {
  vpc_id_second = "vpc-0f13269709c9a4822"
}


inputs = {

  aws_region = "us-east-1"

  name-postfix = "dev-us"

  tags = {
    Environment     = "dev-us",
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

  # vpc_id_first = "Retrieved via the extra args command input"
  vpc_id_second = "vpc-0f13269709c9a4822"

  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
  # CIDR blocks per the ./<repo-root>/cidr-ranges.md
  subnets_cidr = ["172.17.104.16/28", "172.17.104.32/28", "172.17.104.48/28"]
}

dependencies {
  paths = ["../../transit-gateway", "../../vpc/dev-us"]
}

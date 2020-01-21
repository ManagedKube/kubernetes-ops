include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/aws/networks/transit-gateway/"

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

  amazon_side_asn = "64602"

  tags = {
    Name            = "tg-production",
    Environment     = "tg-production",
    Account         = "infrastructure",
    Group           = "devops",
    Region          = "us-east-2"
    managed_by      = "Terraform"
    purpose         = "transit-gateway"
    terragrunt_dir = get_terragrunt_dir()
    last_callers_identity = get_aws_caller_identity_arn()
    last_callers_user_id  = get_aws_caller_identity_user_id()
  }
}

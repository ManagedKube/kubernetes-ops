include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../../tf-modules/aws/vpc/"

  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/us-west-2/_env_defaults/aws.tfvars",
    ]
  }
}

inputs = {

  region = "us-west-2"
  availability_zones            = ["us-west-2a"]

  public_cidrs                  = ["10.37.10.0/24"]

  private_cidrs                 = ["10.37.11.0/24"]

  tags = {
    Name            = "production-test-vpc",
    Environment     = "production-test-vpc",
    Account         = "infrastructure",
    Group           = "devops",
    Region          = "us-west-2"
    managed_by      = "Terraform"
    terraform_module = "vpc"
    terragrunt_dir = get_terragrunt_dir()
    last_callers_identity = get_aws_caller_identity_arn()
    last_callers_user_id  = get_aws_caller_identity_user_id()
  }

}

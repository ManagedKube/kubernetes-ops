terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
  terraform {
    source = "../../../../tf-modules/aws/vpc/"
  }
}

region                        = "us-east-1"
vpc_cidr                      = "10.10.0.0/16"

availability_zones            = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_cidrs                  = ["10.10.6.0/24", "10.10.7.0/24", "10.10.8.0/24"]

private_cidrs                 = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

tags = {
  Name            = "dev",
  Environment     = "dev",
  Account         = "dev",
  Group           = "devops",
  Region          = "us-east-1"
  managed_by      = "Terraform"
}

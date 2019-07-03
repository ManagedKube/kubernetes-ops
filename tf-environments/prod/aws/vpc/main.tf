terraform {
  backend "s3" {}
}

# Common modules
module "env_defaults" {
  source = "../../_env_defaults"
}

# Inputs
variable "public_cidrs" {
  description = "CIDR block for public subnets (should be the same amount as AZs)"
  type        = "list"
  default     = ["10.13.6.0/24", "10.13.7.0/24", "10.13.8.0/24"]
}

variable "private_cidrs" {
  description = "CIDR block for private subnets (should be the same amount as AZs)"
  type        = "list"
  default     = ["10.13.1.0/24", "10.13.2.0/24", "10.13.3.0/24"]
}

# Main
module "main" {
  source                        = "../../../../tf-modules/aws/vpc/"

  region                        = "${module.env_defaults.aws_region}"
  vpc_cidr                      = "${module.env_defaults.vpc_cidr}"

  availability_zones            = ["${module.env_defaults.aws_region}${module.env_defaults.aws_availability_zone_1}", "${module.env_defaults.aws_region}${module.env_defaults.aws_availability_zone_2}", "${module.env_defaults.aws_region}${module.env_defaults.aws_availability_zone_3}"]

  public_cidrs                  = "${var.public_cidrs}"

  private_cidrs                 = "${var.private_cidrs}"

  tags = {
    Name            = "${module.env_defaults.environment_name}",
    Environment     = "${module.env_defaults.environment_name}",
    Account         = "${module.env_defaults.environment_name}",
    Group           = "devops",
    Region          = "${module.env_defaults.aws_region}"
    managed_by      = "Terraform"
  }
}


# Outputs
output "aws_vpc_id" {
  value = "${module.main.aws_vpc_id}"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../tf-modules/aws/rds/"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name                          = "rds-dev"
  identifier                    = "rds-dev"
  group                         = "foo"
  application                   = "bar"

  vpc_id                        = dependency.vpc.outputs.aws_vpc_id

  subnet_1_cidr                 = "10.10.100.0/28"
  subnet_2_cidr                 = "10.10.100.16/28"
  ingress_cidr_blocks           = ["10.10.0.0/16"]

  az_1                          = "us-east-1a"
  az_2                          = "us-east-1b"

  instance_class                = "db.t3.medium"

  username                      = "foo"
  password                      = "barbarbar"

  replicate_source_db           = ""
  kms_key_id                    = ""
  multi_az                      = true

}

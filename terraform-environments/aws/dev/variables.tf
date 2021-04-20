variable "aws_region" {
  default = "us-west-2"
}

variable "environment_name" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "tags" {
  type    = map
  default = {
    ops_env              = "dev"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/dev/eks",
    ops_owners           = "devops"
  }
}

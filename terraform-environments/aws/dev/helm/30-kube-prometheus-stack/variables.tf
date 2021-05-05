variable "aws_region" {
  default = "us-east-1"
}

variable "environment_name" {
  default = "staging"
}

variable "tags" {
  type = map(any)
  default = {
    ops_env              = "staging"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/staging",
    ops_owners           = "devops",
  }
}

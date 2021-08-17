
variable "aws_region" {
  default = "us-east-1"
}

variable "environment_name" {
  default = "dev"
}

variable "tags" {
  type = map(any)
  default = {
    ops_env              = "dev"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/dev/helm/31-grafana-loki",
    ops_owners           = "devops",
  }
}

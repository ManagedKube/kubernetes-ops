variable "backend_organization" {}
variable "workspace_name" {}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = var.backend_organization
    workspaces = {
      name = var.workspace_name
    }
  }
}

output "all_outputs" {
  value = data.terraform_remote_state.eks.outputs
}

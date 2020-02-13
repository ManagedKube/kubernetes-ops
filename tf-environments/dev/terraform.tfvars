terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket     = "kubernetes-ops-1234-kops-state-store"
      key        = "dev/${path_relative_to_include()}/terraform.tfstate"
      region     = "us-east-1"
      encrypt    = true
      # dynamodb_table = "terraform-locks"
    }
  }
}

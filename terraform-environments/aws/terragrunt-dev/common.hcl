locals {
  environment_name = "terraform-dev"
  ## This is used for 050-github-aws-permissions
  ## This string MUST be exactly what is used in github because this
  ## string is matched for AWS authentication and it is case sensitive.
  ## If your repository has upper case, it should reflect that in the string value.
  ## The github URL to your repo (org/repo-name) has the correct string to use.
  repository_name      = "ManagedKube/kubernetes-ops"
  base_repository_path = "terraform-environments/aws/terraform-dev"
  lets_encrypt_email   = "info@managedkube.com"
}

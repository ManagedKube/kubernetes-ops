locals {
    environment_name = "terraform-dev"
    ## This is used for 050-github-aws-permissions.  This should be all lower case.
    repository_name = "managedkube/kubernetes-ops"
    base_repository_path = "terraform-environments/aws/terraform-dev"
    lets_encrypt_email = "info@managedkube.com"
}

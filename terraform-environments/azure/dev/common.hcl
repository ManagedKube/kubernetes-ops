locals {

    repository_name = "kubernetes-ops"
    base_repository_path = "terraform-environments/azure/dev"
    terraform_cloud = {
        organization = "managedkube"
        base_prefix  = "kubernetes-ops"
    }
}

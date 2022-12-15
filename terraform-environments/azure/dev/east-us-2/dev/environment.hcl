locals {
  azure_resource_group_name = "kubernetes-ops-dev"

  # must be globally unique
  vault_name                = "vault-001"

  root_domain_name = "managedkube.com"

  aks_cluster_name = "dev"

  domain_name = "dev.managedkube.com"
}

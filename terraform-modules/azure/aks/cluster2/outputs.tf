output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "oidc_issuer_url" {
  value = module.aks_cluster.oidc_issuer_url
}

output "aks_cluster_all" {
  sensitive = true
  value = module.aks_cluster
}

output "aks_cluster_cluster_fqdn" {
  sensitive = true
  value = module.aks_cluster.cluster_fqdn
  description = "The public/private FQDN"
}

output "aks_id" {
  value = module.aks_cluster.aks_id
}

output "aks_name" {
  value = module.aks_cluster.aks_name
}

output "location" {
  value = module.aks_cluster.location
}

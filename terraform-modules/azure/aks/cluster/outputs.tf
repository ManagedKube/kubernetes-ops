output "cluster_id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.cluster.oidc_issuer_url
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "azurerm_resource_group_id" {
  value = data.azurerm_resource_group.this.id
}

output "azurerm_resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "azurerm_resource_group_location" {
  value = data.azurerm_resource_group.this.location
}

# output "admin_host" {
#   sensitive = true
#   value     = azurerm_kubernetes_cluster.cluster.admin_host
# }

# output "cluster_fqdn" {
#   sensitive = true
#   value     = azurerm_kubernetes_cluster.cluster.cluster_fqdn
# }

# output "cluster_portal_fqdn" {
#   sensitive = true
#   value     = azurerm_kubernetes_cluster.cluster.cluster_portal_fqdn
# }

# output "cluster_private_fqdn" {
#   sensitive = true
#   value     = azurerm_kubernetes_cluster.cluster.cluster_private_fqdn
# }

# output "host" {
#   sensitive = true
#   value     = azurerm_kubernetes_cluster.cluster.host
# }

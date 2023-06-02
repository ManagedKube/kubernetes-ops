data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                            = var.cluster_name
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  kubernetes_version              = var.kubernetes_version
  private_cluster_enabled         = var.private_cluster_enabled
  dns_prefix                      = var.dns_prefix
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  enable_pod_security_policy      = var.enable_pod_security_policy

  local_account_disabled            = var.local_account_disabled
  role_based_access_control_enabled = var.role_based_access_control_enabled

  oidc_issuer_enabled = var.oidc_issuer_enabled

  ## Disabling for now
  # azure_active_directory_role_based_access_control {
  #   managed = var.azure_active_directory_role_based_access_control_managed
  #   tenant_id = var.azure_active_directory_role_based_access_control_tenant_id

  #   # if managed == true the following can be set
  #   admin_group_object_ids = var.azure_active_directory_role_based_access_control_admin_group_object_ids
  #   azure_rbac_enabled     = var.azure_active_directory_role_based_access_control_azure_rbac_enabled
  # }

  network_profile {
    network_plugin = var.network_profile_network_plugin
    network_policy = var.network_profile_network_policy
    pod_cidr       = var.network_profile_pod_cidr
  }

  auto_scaler_profile {
    balance_similar_node_groups = var.auto_scaler_balance_similar_node_groups
    expander                    = var.auto_scaler_expander
  }

  default_node_pool {
    name                   = var.default_node_pool_name
    enable_host_encryption = var.default_node_pool_enable_host_encryption
    node_count             = var.default_node_pool_node_count
    vm_size                = var.default_node_pool_instance_size
    enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
    max_count              = var.default_node_pool_max_count
    min_count              = var.default_node_pool_min_count
    os_disk_size_gb        = var.default_node_pool_os_disk_size_gb
    vnet_subnet_id         = var.default_node_pool_vnet_subnet_id

    node_labels = var.default_node_pool_node_labels
    node_taints = var.default_node_pool_node_taints
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Sourcing this so that we can output this data.  This will help downstream
# items such as the azure-workload-identity helm chart to get the tenant ID.
data "azurerm_client_config" "current" {
}

# variable "location" {
#   default = "eastus2"
# }

variable "resource_group_name" {
  default = "kubernetes-ops-aks"
}

variable "tags" {
  type = map(string)

  default = {
    Name        = "dev"
    Environment = "env"
    Account     = "dev"
    Group       = "devops"
    Location    = "East US 2"
    managed_by  = "Terraform"
  }
}

variable "cluster_name" {
  default = "dev"
}

variable "dns_prefix" {
  default = "dev"
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to false."
}

variable "kubernetes_version" {
  default = "1.24.3"
}

variable "private_cluster_enabled" {
  default = false
}

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = ["1.1.1.1/32"]
}

variable "enable_pod_security_policy" {
  default = false
}

variable "role_based_access_control_enabled" {
  default = true
}

variable "default_node_pool_name" {
  default = "default"
}

variable "default_node_pool_node_count" {
  default = 1
}

variable "default_node_pool_instance_size" {
  default = "Standard_B2s"
}

variable "default_node_pool_enable_auto_scaling" {
  default = true
}

variable "default_node_pool_max_count" {
  default = 1
}

variable "default_node_pool_min_count" {
  default = 1
}

variable "default_node_pool_os_disk_size_gb" {
  default = "30"
}

variable "default_node_pool_node_labels" {
  type    = map(string)
  default = {}
}

variable "default_node_pool_node_taints" {
  type    = list(string)
  default = []
}


variable "network_profile_network_plugin" {
  default = "kubenet"
}

variable "network_profile_network_policy" {
  default = "calico"
}

variable "network_profile_pod_cidr" {
  default = "10.244.0.0/16"
}

variable "kube_dashboard_enabled" {
  default = false
}

variable "default_node_pool_enable_host_encryption" {
  default = true
}

variable "auto_scaler_balance_similar_node_groups" {
  default = false
}

variable "auto_scaler_expander" {
  default = "least-waste"
}

variable "local_account_disabled" {
  type = bool
  default = true
  description = "(Optional) - If true local accounts will be disabled. Defaults to true.  This forces the usage of Azure AD auth (which shold be what you want)."
}

variable "azure_active_directory_role_based_access_control_managed" {
  type = bool
  default = true
  description = "Optional) Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
}

variable "azure_active_directory_role_based_access_control_tenant_id" {
  type = string
  default = null
  description = "(Optional) The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used."
}

variable "azure_active_directory_role_based_access_control_admin_group_object_ids" {
  type = list
  default = []
  description = "When managed is set to true the following properties can be specified.  (Optional) A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
}

variable "azure_active_directory_role_based_access_control_azure_rbac_enabled" {
  type = bool
  default = true
  description = "When managed is set to true the following properties can be specified.  (Optional) Is Role Based Access Control based on Azure AD enabled?"
}

variable "oidc_issuer_enabled" {
  type = bool
  default = true
  description = "(Required) Enable or Disable"
}

variable "default_node_pool_vnet_subnet_id" {
  type = string
  default = null
  description = "The vnet subnet ID to put the default node pool into"
}

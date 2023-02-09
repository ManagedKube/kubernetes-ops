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

variable "api_server_authorized_ip_ranges" {
  type    = list(string)
  default = ["1.1.1.1/32"]
}

variable "enable_pod_security_policy" {
  default = false
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

variable "agents_count" {
  type = number
  default = null
  description = "The number of Agents that should exist in the Agent Pool. Please set agents_count null while enable_auto_scaling is true to avoid possible agents_count changes."
}

variable "enable_auto_scaling" {
  type = bool
  default = true
  description = "Enable node pool autoscaling	"
}

variable "enable_host_encryption" {
  type = bool
  default = false
  description = "Enable Host Encryption for default node pool. Encryption at host feature must be enabled on the subscription: https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli		"
}

variable "agents_tags" {
  type = any
  default = {}
  description = "Additional tags on the default node pool"
}

variable "maintenance_window" {
  type = any
  default = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = []
  }
  description = "(Optional) A maintenance_window block as defined below."
}

variable "agents_availability_zones" {
  type = list(string)
  default = ["1", "2", "3"]
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
}

variable "rbac_aad" {
  type = bool
  default = true
  description = "(Optional) Is Azure Active Directory ingration enabled?	"
}

variable "rbac_aad_managed" {
  type = bool
  default = true
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration.	"
}

variable "role_based_access_control_enabled" {
  type = bool
  default = true
  description = "Enable Role Based Access Control.	"
}

variable "sku_tier" {
  type = string
  default = "Free"
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid	"
}

variable "private_cluster_enabled" {
  type = bool
  default = false
}

variable "workload_identity_enabled" {
  type = bool
  default = true
}

variable "rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access."
  type        = list(string)
  default     = []
}

variable "create_default_admin_group" {
  description = "Should this module create the default admin group for you.  If not, you will have to populate the rbac_aad_admin_group_object_ids variable for access to this cluster."
  type        = bool
  default     = true
}

variable "default_admin_group_name" {
  description = "The name of the default admin group"
  type        = string
  default     = "aks_admins"
}

variable "default_admin_group_members" {
  description = "A list of the group member to add into the default_admin_group.  The items in the list are the user's object ID"
  type        = list(string)
  default     = []
}

variable "default_admin_group_owners" {
  description = "Optional) A set of object IDs of principals that will be granted ownership of the group. Supported object types are users or service principals. By default, the principal being used to execute Terraform is assigned as the sole owner. Groups cannot be created with no owners or have all their owners removed."
  type        = list(string)
  default     = []
}

variable "private_dns_zone_id" {
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created."
  default     = null
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = "${cluster_name}"
  resource_group_name = "${cluster_resource_group}"
}

# Docs: https://registry.terraform.io/providers/hashicorp/helm/latest/docs
provider "helm" {
  kubernetes {
    ## Using the format() function b/c this is a templated file and doing regular string concat with the $ {var}
    ## is producing error and we would need to escape that.  For example even in this comment the template string needed
    ## to be separated out
    host = format("https://%s", data.azurerm_kubernetes_cluster.cluster.fqdn)

    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  }
}

# Doc: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
# Doc: https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider#configure-the-provider
provider "kubernetes" {
  ## Using the format() function b/c this is a templated file and doing regular string concat with the $ {var}
  ## is producing error and we would need to escape that.  For example even in this comment the template string needed
  ## to be separated out
  host = format("https://%s", data.azurerm_kubernetes_cluster.cluster.fqdn)

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)

}

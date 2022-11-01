# Azure AKS

## Source docs
Various sources that attributed to this module:
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
* https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks


## Getting the kubeconfig

```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```


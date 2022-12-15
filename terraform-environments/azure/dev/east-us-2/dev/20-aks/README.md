# Azure AKS

## Getting the kubeconfig

```
az aks get-credentials --resource-group kubernetes-ops-dev --name dev01 --public-fqdn
```

Pre-req:
* kubelogin binary (https://github.com/Azure/kubelogin)
* The kubeconfig uses this binary to get the auth information

## Azure AKS RBAC
Doc: https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac

```
# Get your AKS Resource ID
AKS_ID=$(az aks show --resource-group kubernetes-ops-dev --name dev01 --query id -o tsv)
```

```
AAD_ENTITY_ID="0e3b5f48-02a3-4315-9b8b-9e4131e102ab"

az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee $AAD_ENTITY_ID --scope $AKS_ID
```
* Failed, need additional permissions



# terragrunt
```
export KUBE_CONFIG_PATH=$KUBECONFIG
```

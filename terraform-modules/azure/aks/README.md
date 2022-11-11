# Azure AKS

## Source docs
Various sources that attributed to this module:
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
* https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks


## Getting the kubeconfig

```
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
```

Pre-req:
* kubelogin binary (https://github.com/Azure/kubelogin)
* The kubeconfig uses this binary to get the auth information

## Give users AKS/Kubernetes Permissions

In Azure there are "Azure RBAC" which are like AWS Roles/Policies.
* https://learn.microsoft.com/en-us/azure/aks/concepts-identity

Flow:
```
User   --> Authentication --> Authorization --> Kubernetes API Server
Call
                ^              ^       ^
                |              |       |
            Active           Azure   Kubernetes
            Directory        RBAC       RBAC
```
(Comes from one of the diagrams in the link above)
* In this scenario, you use Azure RBAC mechanisms and APIs to assign users built-in roles or create custom roles, just as you would with Kubernetes roles.
* For example, you can grant the Azure Kubernetes Service RBAC Reader role on the subscription scope. The role recipient will be able to list and get all Kubernetes objects from all clusters without modifying them.


## Giving AKS Kubernetes Service Accounts access to Azure Resources
* https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview
  * Information about what this is
* https://learn.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity
  * Information on how to set it up via the az cli

For example, a Kubernetes pod stores files in Azure Storage, and when it needs to access those files, the pod authenticates itself against the resource as an Azure managed identity.

Integrate with the Kubernetes native capabilities to federate with any external identity providers
* This method is the OIDC Federation method


Use:
* Use an Azure AD workload identity (preview) on Azure Kubernetes Service (AKS)

The names are confusing but this is important to make sure you are using the correct authentication
type.  There is this new type that Azure is going forward with and the old type (right below this) that Azure is deprecating.  A lot of docs for third party packages like the external-secrets and
things will still refer to the older non-supported auth model.








https://azure.github.io/azure-workload-identity/docs/quick-start.html#5-create-a-kubernetes-service-account
* Steps to create a kubernetes service account
* steps to federate the identity creds and the service account identity???
* Found it from here in the external-sercrets Azure setup: https://external-secrets.io/v0.6.1/provider/azure-key-vault/#workload-identity
  * A little confusing b/c Azure does have multiple ways to auth at the moment with the older
    deprecated way and the new workload identity method



Steps (from the above external-secrets link)

1. create the kubernetes service account
```
apiVersion: v1
kind: ServiceAccount
metadata:
  # this service account was created by azwi
  name: workload-identity-sa
  annotations:
    azure.workload.identity/client-id: 7d8cdf74-xxxx-xxxx-xxxx-274d963d358b   <--not a secret
    azure.workload.identity/tenant-id: 5a02a20e-xxxx-xxxx-xxxx-0ad5b634c5d8   <--not a secret
```

2. Configure the trust relationship between Azure AD and Kubernetes 
* https://azure.github.io/azure-workload-identity/docs/quick-start.html#6-establish-federated-identity-credential-between-the-identity-and-the-service-account-issuer--subject

```
azwi serviceaccount create phase federated-identity \
  --aad-application-name "${APPLICATION_NAME}" \
  --service-account-namespace "${SERVICE_ACCOUNT_NAMESPACE}" \
  --service-account-name "${SERVICE_ACCOUNT_NAME}" \
  --service-account-issuer-url "${SERVICE_ACCOUNT_ISSUER}"
```
* Should find the "terraform" way to do this


3. Deploy the workload

```
apiVersion: v1
kind: Pod
metadata:
  name: quick-start
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}
spec:
  serviceAccountName: ${SERVICE_ACCOUNT_NAME}       <-------the k8s service account created above
  containers:
    - image: ghcr.io/azure/azure-workload-identity/msal-go
      name: oidc
      env:
      - name: KEYVAULT_NAME
        value: ${KEYVAULT_NAME}
      - name: KEYVAULT_URL
        value: ${KEYVAULT_URL}
      - name: SECRET_NAME
        value: ${KEYVAULT_SECRET_NAME}
  nodeSelector:
    kubernetes.io/os: linux
```





Looks like this guy did it in Terraform!
* https://dev.to/maxx_don/implement-azure-ad-workload-identity-on-aks-with-terraform-3oho

COPY THIS!


The workload identity helm chart:
* https://github.com/Azure/azure-workload-identity/tree/main/charts/workload-identity-webhook



Generic helm for all clouds?
* Instead of a specific aws or azure one for external-secrets, external-dns, etc
* Can we create one cloud generic one that has switches to enable it for a cloud?
* This will make it easier to maintain going forward for each chart






























### Deprecation: Azure AD pod-managed identity
aka:
* aad-pod-identity

Dont use anything that says something like aad pod identity

Notice: 
* https://azure.github.io/aad-pod-identity/docs/

Replaces the "Azure AD pod-managed identity" method.

We recommend you review Azure AD workload identity (preview). This authentication method replaces pod-managed identity (preview), which integrates with the Kubernetes native capabilities to federate with any external identity providers on behalf of the application.

The open source Azure AD pod-managed identity (preview) in Azure Kubernetes Service has been deprecated as of 10/24/2022.


## Azure/AKS OIDC Federation with external

[WIP]

Doc that talks about it: https://learn.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation


## Security

KMS for etcd
* https://learn.microsoft.com/en-us/azure/aks/use-kms-etcd-encryption



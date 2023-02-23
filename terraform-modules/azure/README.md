Azure Terraform
================

# Authentication methods

https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html


## az cli

### Login

```
az login
```

### List accounts

```
az account list
```

# Storage account
An Azure storage account contains all of your Azure Storage data objects: blobs, files, queues, tables, and disks.

We also use this for the remote Terraform backend.

Quick start guide: https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-cli

## Set parameters

```bash
ENVIRONMENT=dev
RESOURCE_GROUP_NAME=kubernetes-ops-${ENVIRONMENT}
LOCATION="eastus2"
COMPANY_NAME="managedkube" # Your company name here, since these names are globally unique. Lowercase and letters only
STORAGE_ACCOUNT_NAME=kubernetesops${COMPANY_NAME}
CONTAINER_NAME=tfstate
```

## Create a storage group
A resource group is a logical container into which Azure resources are deployed and managed.

```bash
az group create \
    --name ${RESOURCE_GROUP_NAME} \
    --location ${LOCATION}
```

## Create a storage account
The general-purpose storage account can be used for all four services: blobs, files, tables, and queues.

```bash
az storage account create \
    --name ${STORAGE_ACCOUNT_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --location ${LOCATION} \
    --sku Standard_ZRS \
    --encryption-services blob
```

## Create a container
Blobs are always uploaded into a container. You can organize groups of blobs in containers similar to the way you organize your files on your computer in folders.

```bash
az storage container create \
    --account-name ${STORAGE_ACCOUNT_NAME} \
    --name ${CONTAINER_NAME}
```

## List a container

```bash
az storage blob list \
    --account-name ${STORAGE_ACCOUNT_NAME} \
    --container-name ${CONTAINER_NAME} \
    --output table
```

# Enable preview features

https://aka.ms/aks/previews

```
az extension add --name aks-preview
az feature register --name PodSecurityPolicyPreview --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerService
```

# Show tenant
```
az account tenant list

az account show
```

# change tenant:

## sign in as a different user
```
az login --user <myAlias@myCompany.com> -password <myPassword>
```

## sign in with a different tenant
```
az login --tenant <myTenantID>
```

## clear local creds
```
az account clear
```


# AKS Pod Identities
There has been a bunch of changes to the way identities are given to pods and how that identity is
linked/federated to Azure Active Directory so that the pod can access Azure resources without hardcoded
keys given to the pod.

Going forward from (10/2022) the preferred method is:  Azure Workload Identity 
* https://azure.github.io/azure-workload-identity/docs/
* https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview
* https://github.com/kubernetes-sigs/external-dns/issues/2724

```
AWI (Azure Workload Identity) is essentially the equivalent of AWS's IAM Roles for Service Accounts and works the same. I.e, you cluster becomes an OIDC identity provider and a specific service account in a specific namespace can be designated as federated principal to which Azure IAM roles can be attached. This is significantly more secure than using credentials (i.e. Service Principals with client secrets) or Managed Service Identities (for which the whole Node is able to assume the identity).
```

Deprecated:
* AAD Pod Identity (https://github.com/Azure/aad-pod-identity)
  * CRDs: AzureIdentity, AzureIdentityBinding (dont use this!  It is old.)


# Permissions for assigning roles to service principals
A lot of the modules here uses the pattern where it creates a service principal and then assigns
it a role or some permissions which is used by the Helm chart.  For example, giving the external-dns
Helm chart permissions so that it can edit entries in a specific Azure DNS zone.  We do that because
this is the most secure way to grant permissions to k8s pods (and VMs).  There are no passwords/keys or
long lived certs involved.  It is all done via cryptographic identities that are federated with Azure.

If you didnt create the Azure Subscription and were not assigned to the subscription with the proper
role, you might not be able to create the necessary role assignments to the service principal even if
you are a global admin on the account.

This doc describes the permission needed: Doc:
* https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
* https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli

You will see errors such as:
```
Error: authorization.RoleAssignmentsClient#Create: Failure responding to 
request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. 
Status=403 Code="AuthorizationFailed" 
```

Check what role you have: Azure portal -> Subscriptions -> <the subscription in question> -> Settings -> My Permissions -> Go to subscription access control (IAM) -> Check Access -> View My access
* The "contributor" role is not enough.  Per the doc you need: Owner role or User Access Administrator role

To set the user to the proper role:
* Azure portal -> Subscriptions -> <subscription> -> Settings -> My Permissions -> Go to subscription access control (IAM) -> Access Control IAM -> Role Assignment
* Set to either `owner` or `User Access Administrator` role

# To view an Azure Application
* Azure portal -> Azure Active Directory -> Manage -> App Registrations -> All applications

This will list the various applications such as `external-dns`, `external-secrets`, etc

Doc:
* Creating an application and assigning it a role
* https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal

# Azure built in roles list
* https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

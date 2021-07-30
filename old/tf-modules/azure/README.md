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
RESOURCE_GROUP_NAME=kubernetes-ops
LOCATION="East US 2"
STORAGE_ACCOUNT_NAME=kubernetesops
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

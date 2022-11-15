#  kubernetes-external-secrets

Source project: https://github.com/external-secrets/external-secrets
Source chart: https://github.com/external-secrets/external-secrets/tree/main/deploy/charts/external-secrets
Usage Docs: https://external-secrets.io/v0.6.1


## Useful guides

The following guides were used to develop the Azure Workload Identity setup here for external-dns

### End to end Azure setup (general)
Doc: https://dev.to/maxx_don/implement-azure-ad-workload-identity-on-aks-with-terraform-3oho

This is a very good guide for a general Azure Workload Identity setup.  While it doesnt talk
about external-dns it does walk you through all of the steps necessary to get the Workload
Identity working with Terraform and in your Pod.

### End to end Azure Setup (external-dns specific)
Doc: https://external-secrets.io/v0.6.1/provider/azure-key-vault/#workload-identity

While this doc does most of it via CLI.  This is a useful guide on all of the steps needed
to implement the Azure Workload Identity method (which is the recommended method).

## Setup

### (1) Setup an Azure Vault instance
There is an Azure Vault module in the main `azure` folder here or if you already have one, you can use
that.

### (2) Install the external secrets Helm Chart
This installs the external-secrets helm chart

(no azure resources)

### (3) Install the secret_store
One or more of these can be created.

This creates:
* The external-secrets CRD for a ClusterSecretStore
* The Azure app and principals with Azure Workload Identity federation
* K8s service account connected to the Azure Workload Identity


## Testing

### (1) Manually adding a secret
The easiest way is to manually add a secret from the Azure web console:

You will need to first give yourself permissions to this Vault by going here:
* Home -> Key vaults -> <the vault instance> -> Access policies
* Create
* Permissions - all
* Principal - search for your name and select it
* Click through to create the access



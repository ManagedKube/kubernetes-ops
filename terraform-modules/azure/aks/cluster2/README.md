# terraform-azurerm-aks

Source module: https://github.com/Azure/terraform-azurerm-aks

# Enable enableworkloadidentitypreview
The AKS cluster uses the Workload Identity which is still in preview.  To enable, follow these instructions: https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster#register-the-enableworkloadidentitypreview-feature-flag

## Notes:

### Creating two clusters in the same subnets
Current using this module, it is not supported creating two AKS clusters in the same subnets
because AKS requires special routes that the AKS cluster will create for you in the subnet but
if you have two AKS clusters, you have to resolve the custom routing on your own.

Azure documentation describing this: https://learn.microsoft.com/en-us/azure/aks/configure-kubenet#bring-your-own-subnet-and-route-table-with-kubenet

The easy work around for this is to simply add the second AKS cluster into another subnet in the
same vnet.

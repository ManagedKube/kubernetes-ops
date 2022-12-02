# vnet

## Getting a specific subnet output

The subnet output is a set with the following output: 

```
subnets = toset([
  {
    "address_prefix" = "10.131.32.0/21"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Private-1"
    "name" = "Private-1"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
  {
    "address_prefix" = "10.131.40.0/21"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Private-2"
    "name" = "Private-2"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
  {
    "address_prefix" = "10.131.48.0/21"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Private-3"
    "name" = "Private-3"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
  {
    "address_prefix" = "10.131.56.0/23"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Public-1"
    "name" = "Public-1"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
  {
    "address_prefix" = "10.131.58.0/23"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Public-2"
    "name" = "Public-2"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
  {
    "address_prefix" = "10.131.60.0/23"
    "id" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/virtualNetworks/VNET-DEV-EASTUS2-AKS-01/subnets/Public-3"
    "name" = "Public-3"
    "security_group" = "/subscriptions/8eib906c-9die-4ad2-9c2f-b22c1939dieo/resourceGroups/kubernetes-ops-dev/providers/Microsoft.Network/networkSecurityGroups/VNET-DEV-EASTUS2-AKS-01-main"
  },
])
```

You will most likely need a specific one of these items in subsequent usage so that you can get an individual
subnet ID to place the AKS cluster's node pools in or for other uses.  The following describe a method to select a specific output by the subnet name.

Let's say we want the ID of the subnet named: `Private-1`:

```
subnet_id = [for output in <module.this.subnets> : output.id if output.name == "Private-1"][0]
```

`<module.this.subnets>` is the output of this module.

Here is a good stackoverflow on how this is done: https://stackoverflow.com/questions/72064084/extract-values-from-terraform-set-variable

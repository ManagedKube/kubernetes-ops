# External-DNS

Docs:
* Main repo: https://github.com/kubernetes-sigs/external-dns
* https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure.md
* Chart: https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns


# 12/1/22 - Left off
* Was trying to get the Azure Workload Identity going
* Following instructions here: https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure-private-dns.md
* Found out that these instructions are old and is using the older Azure Managed Identity stuff
* There is a ticket/pr out to update to use the Azure Workload Identity stuff: https://github.com/kubernetes-sigs/external-dns/issues/2724
* Waiting for this to merge then we can try it again
* The current external-dns module here has a lot of stuff that is probably not needed for Azure Workload Identity

What might not be needed:
* The `resource "kubernetes_secret_v1" "example"`, `azure.json` file
* The `extraVolumes` in the `helm_values.tpl.yaml` file
* Some of the `extraArgs` items in the `helm_values.tpl.yaml` file


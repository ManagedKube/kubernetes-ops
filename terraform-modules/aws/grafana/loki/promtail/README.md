# Loki Promtail

Source: https://github.com/grafana/loki/tree/main/tools/lambda-promtail

## Why a sub module for this
In the Terraform module, it has a provider with a hardcoded region: https://github.com/grafana/loki/blob/main/tools/lambda-promtail/main.tf#L1
* We need to be able to specify our own region
* When using this with certain Terraform, we are already providing a "Terraform Provider" block and there can only be one

We are basically copying the entire thing at the source here.

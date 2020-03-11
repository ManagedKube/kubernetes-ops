Flux Helm-Operator
====================

Source: https://github.com/fluxcd/helm-operator

Good tutorial: https://github.com/fluxcd/helm-operator-get-started

Very helpful doc on the `HelmRelease` CRD and what it can do:  https://github.com/fluxcd/helm-operator/blob/master/docs/references/helmrelease-custom-resource.md


# Setup

## Apply the `HelmRelease` CRD

```
make ENVIRONMENT=dev apply-crd
```

# Install the helm operator

```
make ENVIRONMENT=dev apply
```

Flux Helm-Operator
====================

Source: https://github.com/fluxcd/helm-operator

Good tutorial: https://github.com/fluxcd/helm-operator-get-started


# Setup

## Apply the `HelmRelease` CRD

```
make ENVIRONMENT=dev apply-crd
```

# Install the helm operator

```
make ENVIRONMENT=dev apply
```

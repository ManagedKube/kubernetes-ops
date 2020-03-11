Prometheus Operator Helm
=========================

Helm Chart: https://github.com/helm/charts/tree/master/stable/prometheus-operator


# Usage

## Install via Tiller

```
make KUBE_NAMESPACE=monitoring VALUES_FILE=values-example-env.yaml install
```

## Install via template
Without using a tiller

```
export KUBE_NAMESPACE=<namespace to install into>
make KUBE_NAMESPACE=${KUBE_NAMESPACE} VALUES_FILE=values-example-env.yaml template

kubectl --namespace ${KUBE_NAMESPACE} apply -f /tmp/output.yaml
```

THis doesnt work, the namespaces are not inserted correctly

# Deployment

### template
```
make ENVIRONMENT=dev-us template
```

### apply
```
make ENVIRONMENT=dev-us install
```

### delete
```
make ENVIRONMENT=dev-us delete
```

Prometheus creates Kubernetes CRDs which should be deleted to remove all Prometheus
traces:

```
make ENVIRONMENT=dev-us delete-crd
```

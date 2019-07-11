Helm Tiller
===============
This Tiller has access to one namespace.  This means it can only deploy applications
to the specified namespace.

You will need to change the namespace value in the `rbac.yaml` file

Documentation: https://github.com/kubernetes/helm/blob/master/docs/rbac.md#example-deploy-tiller-in-a-namespace-restricted-to-deploying-resources-only-in-that-namespace

# RBAC
Since we are using RBAC, we need to give the Tiller admin permissions

```
kubectl create -f rbac.yaml
```

More information about various RBAC setup: https://github.com/kubernetes/helm/blob/master/docs/rbac.md

* Limit Tiller to a namespace
* Limit Tiller to run in one namespace and has access to another namespace

## Start tiller

## create
```
helm init --service-account tiller --tiller-namespace monitoring
```


## update
```
helm init --service-account tiller --tiller-namespace monitoring --upgrade
```

## installing a helm chart
When limiting the Helm Tiller to only a namespace, you have to pass in an additional
argument when you start a helm chart to let it know which Tiller you want to talk to
and the namespace you want to deploy into:

```
helm install --tiller-namespace monitoring --namespace monitoring stable/mongodb-replicaset
```

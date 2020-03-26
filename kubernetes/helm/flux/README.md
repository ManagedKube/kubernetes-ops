Flux Setup
============
Flux is a GitOps workflow tool that runs an operator in each cluster you want it to be able to deploy into.  You link it up with your Git repository and it syncs your repository with your cluster.  This means that if you wanted to deploy something or update something in the Kubernetes cluster, all you have to do is make the changes in the source repository, commit, and push it in.  Flux will check with the source repository every so often and sync what is there to the Kubernetes cluster.  The Flux operator will sync and deploy items based on Kubernetes yaml files only.

Here is the official documentation for reference: [https://docs.fluxcd.io/en/latest/introduction.html](https://docs.fluxcd.io/en/latest/introduction.html)

# Deploy the Flux Operator

```
cd ./flux
```

## Add an environment's values.yaml file

For each environment you want to deploy Flux into and for the Git repository you want it to watch, you will have to configure this.

For example, if you have a dev environment watching this repository, you will make a values file like (`./environments/dev/values.yaml`):

```yaml
flux:
  git:
    url: git@github.com:ManagedKube/kubernetes-ops.git
    branch: master
    path: "kubernetes/flux"
```

This pointing to the repository with the `url` at the `branch` and at a certain path in this repository it is watching.

## Deploy it out to your Kubernetes cluster

```
make ENVIRONMENT=dev apply-crd
make ENVIRONMENT=dev apply
```

## Get the Git public key
For Flux to be able to watch your repository, you will need to add it's public ssh key to your Git repository.

Get the public ssh key:

```
make get-identity
```

This will output a key.

```
In order to sync your cluster state with git you need to copy the public key and create a deploy key with write access on your GitHub repository.

Open GitHub, navigate to your fork, go to Setting > Deploy keys, click on Add deploy key, give it a Title, check Allow write access, paste the Flux public key and click Add key.
```

# Deploy the Flux helm-operator
While the Flux Operator syncs and deploys Kubernetes yaml files, the Flux helm-operator acts on the kind:

```yaml
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
```

With this Flux CRD, we can express Helm deployments in a yaml file and the Flux helm-operator will run the Helm3 commands for us and deploy it in the cluster.  In short, this helps us to sync Helm3 definitions in our Git repository to a Helm deployment in our Kubernetes cluster.

## Deploy

```
cd ./helm-operator
make ENVIRONMENT=dev apply-crd
make ENVIRONMENT=dev apply
```



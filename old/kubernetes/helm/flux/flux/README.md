Weaveworks Flux:
==================

Sourc repo: https://github.com/fluxcd/flux

A great tutorial: https://github.com/fluxcd/helm-operator-get-started


# Setup

## Install the helm chart
You should update the `./environment/dev/values.yaml` file with your Git repository URL.

```
make ENVIRONMENT=dev apply
```

## Get the Git ssh pub key

```
make ENVIRONMENT=dev get-identity
```

In order to sync your cluster state with Git you need to copy the public key and create a deploy key with write access on your GitHub repository.

Open GitHub, navigate to your fork, go to Setting > Deploy keys click on Add deploy key, check Allow write access, paste the Flux public key and click Add key.

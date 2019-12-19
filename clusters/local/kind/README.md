Kind
=======
Kind is an open source project that brings up a local Kuberenetes environment all
running in Docker.

Doc: https://kind.sigs.k8s.io/docs/user/quick-start/


# Installation instructions:

Doc: https://github.com/kubernetes-sigs/kind#installation-and-usage


# Usage:

## Creation:
```
kind create cluster --config config.yaml --image kindest/node:v1.13.12
```

## List
```
kind get clusters
```

## Delete
```
kind delete cluster
```

## Debug
By defaul if the create command fails it will clean up the Docker containers.

You can append the `--retain` flag in the `kind create cluster...` command so 
it won't remove the Docker containers on failure and you can debug the containers
from there.

There is also a verbose flag to give you more information on what it is doing: `--v 7`


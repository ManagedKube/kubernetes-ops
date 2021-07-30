# kops

## What you get
Yes, this is a very opinionated way of doing the upgrade.  It is also very generic.  Nothing that special about it.
It runs through `kops` update process in an automated way.  This is using pure `kops` tooling with Github Actions and
some glue code (mostly in Bash).  

Why do this then?  The only way to "glue" everything together and have it consitently working version to version is to
define how the cluster is defined and created.  Then the automation knows how to handle it.  Without you "subscribing" to
this method on how to manage your `kops` cluster, you would have to maintain all of this yourself.  

While this is just one of many ways to managed a `kops` cluster, we have found that managing a `kops` cluster this way is
very reasonable.  Over the years of our consultancy, we have managed a lot of `kops` clusters this way with a lot of varying
technical "asks" and it mostly handled anything that was asked for.

You get a fully automated `kops` update pipeline to update your kops cluster (with the correct binaries for everything), testing
the cluster after creation, and posting info back to PRs or comments on the output of the update.

## Docs

Task definition doc: [https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#family](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#family)

## What the scripts do:

### setup.sh
This sets up the container.  Downloads things like:
* curl
* kops
* kubectl
* etc

### create-cluster.sh
This script creates a temporary kops cluster.

### e2e-tests.sh
This script runs the e2e tests

### update-cluster.sh
This script updates the cluster

### ci-pipeline.sh

```
./ci-pipeline.sh --initial-branch master --updated-to-branch kops-update-1.4.7
```

## Local workflow

### Build

Run from the root of the repository:

```bash
docker build -t managedkube/kops:dev -f ./containers/kubernetes/clusters/kops/Dockerfile .
```

### Dev local
Run from the root of this repository:

```bash
docker run -ti \
-e ENVIRONMENT_NAME=${ENVIRONMENT_NAME} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
-e KOPS_STATE_STORE=${KOPS_STATE_STORE} \
-v ${PWD}:/opt/repo \
managedkube/kops:dev bash
```

### Push

```bash
docker push managedkube/kops:dev
```

### Running
Export variables:
```bash
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="us-east-1"
export KOPS_STATE_STORE=""
export ENVIRONMENT_NAME=dev-test
```

```bash
docker run -ti \
-e ENVIRONMENT_NAME=${ENVIRONMENT_NAME} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
-e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
-e KOPS_STATE_STORE=${KOPS_STATE_STORE} \
managedkube/kops:dev bash
```

run the cluster update:
```
./containers/kubernetes/clusters/kops/update-cluster.sh
```

run the Kubernetes e2e tests:
```
./containers/kubernetes/clusters/kops/e2e-tests.sh
```
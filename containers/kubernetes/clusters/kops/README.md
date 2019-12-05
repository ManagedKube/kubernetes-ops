# kops-update

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
./containers/kops/update-cluster.sh
```

run the Kubernetes e2e tests:
```
./containers/kops/e2e-tests.sh
```
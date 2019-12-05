# kops-update

## Local workflow

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
managedkube/kops-update:dev bash
```

### Build

Run from the root of the repository:

```bash
docker build -t managedkube/kops-update:dev -f ./containers/kops-update/Dockerfile .
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
managedkube/kops-update:dev bash
```

run the cluster update:
```
./containers/kops-update/update-cluster.sh
```

run the Kubernetes e2e tests:
```
./containers/kops-update/e2e-tests.sh
```
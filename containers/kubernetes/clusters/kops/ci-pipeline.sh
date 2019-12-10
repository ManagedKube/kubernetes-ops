#!/bin/bash -e

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

# Parse inputs
while [ "$1" != "" ]; do
    case $1 in
        -i | --initial-branch )           shift
                                INITIAL_BRANCH=$1
                                ;;
        -u | --updated-to-branch )        shift
                                UPDATE_TO_BRANCH=$1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Check input params
if [ -z "${INITIAL_BRANCH}" ]; then
  echo "The --initial-branch param must be set"
  exit 1
fi

if [ -z "${UPDATE_TO_BRANCH}" ]; then
  echo "The --updated-to-branch param must be set"
  exit 1
fi

BASE_FILE_PATH="./containers/kubernetes/clusters/kops"

message_banner() {
    echo "#################################"
    echo "#################################"
    echo "$1"
    echo "#################################"
    echo "#################################"
}

function wait_for_kube_api_ready() {
    until kubectl get nodes
    do
        echo "Cannot reach the Kubernetes cluster yet.  Wait and try again..."
        sleep 2
    done
}


# Checkout the INITIAL_BRANCH branch
message_banner "git checkout ${INITIAL_BRANCH}"
git checkout ${INITIAL_BRANCH}

# Create initial cluster
# message_banner "Creating initial cluster"
# ${BASE_FILE_PATH}/create-cluster.sh

# Wait for kube api to be ready:
wait_for_kube_api_ready

# Get the cluster name
CLUSTER_NAME=$(cat ./tmp-output/cluster-name.txt)

# Run e2e tests
message_banner "Running e2e tests"
# ${BASE_FILE_PATH}/e2e-tests.sh


# Checkout the UPDATE_TO_BRANCH branch
message_banner "git checkout ${UPDATE_TO_BRANCH}"
git checkout ${UPDATE_TO_BRANCH}

# Copy ci-pipeline kops yaml to the newly created cluster's yaml
cp -a ./clusters/aws/kops/clusters/ci-pipeline/* ./clusters/aws/kops/clusters/${CLUSTER_NAME}/

exit 1

# Update the cluster
message_banner "Updating the cluster"
${BASE_FILE_PATH}/update-cluster.sh

# Run e2e tests
message_banner "Running e2e tests"
${BASE_FILE_PATH}/e2e-tests.sh

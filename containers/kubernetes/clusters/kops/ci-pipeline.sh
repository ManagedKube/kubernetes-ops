#!/bin/bash -ex

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

message_banner() {
    echo "#################################"
    echo "#################################"
    echo "$1"
    echo "#################################"
    echo "#################################"
}

# Checkout the INITIAL_BRANCH branch
message_banner "git checkout ${INITIAL_BRANCH}"
git checkout ${INITIAL_BRANCH}

# Create initial cluster
message_banner "Creating initial cluster"
./create-cluster.sh

# Get the cluster name
CLUSTER_NAME=$(cat ./tmp-output/cluster-name.txt)

# Run e2e tests
message_banner "Running e2e tests"
./e2e-tests.sh ${CLUSTER_NAME}

# Checkout the UPDATE_TO_BRANCH branch
message_banner "git checkout ${UPDATE_TO_BRANCH}"
git checkout ${UPDATE_TO_BRANCH}

# Update the cluster
message_banner "Updating the cluster"
./update-cluster.sh

# Run e2e tests
message_banner "Running e2e tests"
./e2e-tests.sh ${CLUSTER_NAME}

#!/bin/bash -e

###################################################
##
## This script run inside of the Fargate Docker container.
##
## Need to rebuild Docker container on edit: true
##
###################################################

echo "###################################################"
echo "running: ci-pipeline.sh"
echo "###################################################"

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

usage()
{
    echo "usage: TBD"
}

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

# Removing "/refs/heads/" from the branch name
UPDATE_TO_BRANCH_PRUNED=$(echo "refs/heads/dynamic-branch" | sed 's/refs\/heads\///')

# Checkout the INITIAL_BRANCH branch
set -x
git fetch
set +x
message_banner "git checkout ${INITIAL_BRANCH}"
set -x
git pull origin ${INITIAL_BRANCH}
git checkout ${INITIAL_BRANCH}
set +x

# # Create initial cluster
message_banner "Creating initial cluster"
${BASE_FILE_PATH}/create-cluster.sh

# Get the cluster name
CLUSTER_NAME=$(cat ./tmp-output/cluster-name.txt)

# Run e2e tests
message_banner "Running e2e tests"
${BASE_FILE_PATH}/e2e-tests.sh || true

# Checkout the UPDATE_TO_BRANCH_PRUNED branch
message_banner "git checkout ${UPDATE_TO_BRANCH_PRUNED}"
set -x
git checkout ${UPDATE_TO_BRANCH_PRUNED}
set +x

# Copy ci-pipeline kops yaml to the newly created cluster's yaml
set -x
cp -a ./clusters/aws/kops/clusters/ci-pipeline/* ./clusters/aws/kops/clusters/${CLUSTER_NAME}/
set +x

echo "Replace kops values file with the correct name parameters"
set -x
sed -i "s/ci-pipeline/${CLUSTER_NAME}/g" ./clusters/aws/kops/clusters/${CLUSTER_NAME}/values.yaml
set +x

# Update the cluster
message_banner "Updating the cluster"
${BASE_FILE_PATH}/update-cluster.sh

# Run e2e tests
message_banner "Running e2e tests"
${BASE_FILE_PATH}/e2e-tests.sh || true

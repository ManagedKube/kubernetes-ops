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

# Checkout the INITIAL_BRANCH branch
git checkout ${INITIAL_BRANCH}

# Create initial cluster
./create-cluster.sh

# Checkout the UPDATE_TO_BRANCH branch
git checkout ${UPDATE_TO_BRANCH}

# Get the cluster name
CLUSTER_NAME=$(cat ./tmp-output/cluster-name.txt)

./e2e-tests.sh ${CLUSTER_NAME}

./update-cluster.sh

./e2e-tests.sh ${CLUSTER_NAME}
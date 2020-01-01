#!/bin/bash -ex

CLUSTER_NAME_PREFIX="ci-pipeline"

if [ "${DELETE_PREVIOUS_CLUSTER}" == "true" ]; then
    # Delete all cluster staring with ${CLUSTER_NAME_PREFIX} in the name
    kops get clusters --skip_headers | grep -e "^${CLUSTER_NAME_PREFIX}.*" | awk '{print $1}' | xargs kops delete cluster --yes
fi

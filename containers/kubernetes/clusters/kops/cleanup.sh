#!/bin/bash -e

###################################################
##
## This script run inside of Github Actions.
##
## Need to rebuild Docker container on edit: false
##
###################################################

CLUSTER_NAME_PREFIX="ci-pipeline"

if [ "${DELETE_PREVIOUS_CLUSTER}" == "true" ]; then
    
    # Loop through the kops get clusters output and get each cluster name
    for row in $(kops get clusters --output json | jq -r '.[] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        CLUSTER_NAME=$(_jq '.metadata.name')

        # Delete all cluster staring with ${CLUSTER_NAME_PREFIX} in the name
        if echo ${CLUSTER_NAME} | grep -e "^${CLUSTER_NAME_PREFIX}"; then

            echo "Deleting cluster: ${CLUSTER_NAME}"
            kops delete cluster ${CLUSTER_NAME} --yes
        fi
    done

fi

#!/bin/bash -e

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

###################################################
##
## This script run inside of Github Actions.
##
## Need to rebuild Docker container on edit: false
##
###################################################

CLUSTER_NAME_PREFIX="ci-pipeline"

if [ "${DELETE_PREVIOUS_CLUSTER}" == "true" ]; then

    # Kops returns an array of clusters if there are more than one.
    # If there is only one, it returns a json element with just one element
    # We have to treat these two cases differently.
    NUMBER_OF_CLUSTERS=$(kops get clusters | wc -l)
    if [ "${NUMBER_OF_CLUSTERS}" -eq 2 ]; then
        echo "There is one cluster."

        CLUSTER_NAME=$(kops get clusters --output json | jq -r .metadata.name)

        # Delete all cluster staring with ${CLUSTER_NAME_PREFIX} in the name
        if echo ${CLUSTER_NAME} | grep -e "^${CLUSTER_NAME_PREFIX}"; then

            echo "Deleting cluster: ${CLUSTER_NAME}"
            set -x
            kops delete cluster ${CLUSTER_NAME} --yes
            set +x
        fi
    else

        # Loop through the kops get clusters output and get each cluster name
        for row in $(kops get clusters --output json | jq -r '.[] | @base64'); do
            _jq() {
                echo ${row} | base64 --decode | jq -r ${1}
            }

            CLUSTER_NAME=$(_jq '.metadata.name')

            # Delete all cluster staring with ${CLUSTER_NAME_PREFIX} in the name
            if echo ${CLUSTER_NAME} | grep -e "^${CLUSTER_NAME_PREFIX}"; then

                echo "Deleting cluster: ${CLUSTER_NAME}"
                set -x
                kops delete cluster ${CLUSTER_NAME} --yes
                set +x
            fi
        done

    fi

fi

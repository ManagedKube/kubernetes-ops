#!/bin/bash -e

###################################################
##
## This script run inside of the Fargate Docker container.
##
## Need to rebuild Docker container on edit: true
##
###################################################

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

#CLOUD_ONLY="--cloudonly true"

# Set the environment name to the tmp-output name if it exist
if [ -a ./tmp-output/cluster-name.txt ]; then
    ENVIRONMENT_NAME=$(cat ./tmp-output/cluster-name.txt)
    echo "ENVIRONMENT_NAME: ${ENVIRONMENT_NAME}"
fi

cd ./clusters/aws/kops/

echo "Apply kops update [DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --update true --dry-run true
sleep 5

echo "Apply kops update [NOT DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --update true --dry-run false

echo "Apply kops rolling update [DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --rolling-update true ${CLOUD_ONLY} --dry-run true

echo "Apply kops rolling update [NOT DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --rolling-update true ${CLOUD_ONLY} --dry-run false

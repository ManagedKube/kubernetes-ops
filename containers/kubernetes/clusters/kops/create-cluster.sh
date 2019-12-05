#!/bin/bash -ex

CLUSTER_NAME=ci-pipeline

echo "Generate random UUID"
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)

CLUSTER_NAME=ci-pipeline-${NEW_UUID}

echo "Copy ci-pipeline folder for this CI run's usage"
cp -a ./clusters/aws/kops/clusters/ci-pipeline ./clusters/aws/kops/clusters/${CLUSTER_NAME}

echo "Output cluster name into the cluster's values directory"
echo "${CLUSTER_NAME}" > ./clusters/aws/kops/clusters/${CLUSTER_NAME}/cluster-name.txt

echo "Replace kops values file with the correct name parameters"
sed -i "s/ci-pipeline/${CLUSTER_NAME}/g" ./clusters/aws/kops/clusters/${CLUSTER_NAME}/values.yaml

cd ./clusters/aws/kops/

echo "Creating a new kops cluster [DRY RUN]"
./kops.sh --name ${CLUSTER_NAME} --create true --dry-run true

echo "Creating a new kops cluster [NOT DRY RUN]"
./kops.sh --name ${CLUSTER_NAME} --create true --dry-run false

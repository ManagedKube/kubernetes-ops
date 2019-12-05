#!/bin/bash -ex

cd ./containers/kubernetes/clusters/kops

echo "Apply kops update [DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --update true --dry-run true
sleep 5

echo "Apply kops update [NOT DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --update true --dry-run false

echo "Apply kops rolling update [DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --rolling-update true --cloudonly true --dry-run true

echo "Apply kops rolling update [NOT DRY RUN]"
./kops.sh --name ${ENVIRONMENT_NAME} --rolling-update true --cloudonly true --dry-run false

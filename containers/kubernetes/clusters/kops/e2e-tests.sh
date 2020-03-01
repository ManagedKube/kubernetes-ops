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

echo "Run sonobuoy Kubernetes e2e tests"
echo "Running e2e tests"

# Delete previous test
sonobuoy delete --all --wait

if [ ! -z "${E2E_TESTS_QUICK_MODE}" ]; then
  # Quick test
  sonobuoy run --mode quick --wait
else
  # Long test
  sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --wait
fi

# Get results
results=$(sonobuoy retrieve)
sonobuoy results $results
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

echo "##################################################"
echo "# sonobuoy logs: start"
echo "##################################################"
echo "Run sonobuoy Kubernetes e2e tests"
echo "Running e2e tests"

# Delete previous test
sonobuoy delete --all --wait

if [ ! -z "${E2E_TESTS_QUICK_MODE}" ]; then
  # Quick test
  set -x
  sonobuoy run --mode quick --wait
  set +x
else
  # Long test
  set -x
  #sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --wait
  sonobuoy run --e2e-focus="\\[StatefulSetBasic\\]" --e2e-skip="(\[Conformance\])" --wait
  sonobuoy status
  set +x
fi

# Output Logs
echo "##################################################"
echo "# sonobuoy logs: start"
echo "##################################################"
set -x
sonobuoy logs
set +x
echo "##################################################"
echo "# sonobuoy logs: end"
echo "##################################################"

# Get results
set -x
results=$(sonobuoy retrieve)
sonobuoy results $results
set +x


echo "##################################################"
echo "# sonobuoy run: end"
echo "##################################################"
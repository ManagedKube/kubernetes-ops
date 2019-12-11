#!/bin/bash -e

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

echo "Run sonobuoy Kubernetes e2e tests"
echo "Running e2e tests"

# Delete previous test
sonobuoy delete --all --wait

<<<<<<< HEAD
# Long test
# sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --wait

# Quick test
sonobuoy run --mode quick --wait
=======
if [ ! -z "${E2E_TESTS_QUICK_MODE}" ]; then
  # Quick test
  sonobuoy run --mode quick --wait
else
  # Long test
  sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --wait
fi
>>>>>>> cfd18a2c68d4f4a33843a54cbb683c865a06f244

# Get results
results=$(sonobuoy retrieve)
sonobuoy results $results
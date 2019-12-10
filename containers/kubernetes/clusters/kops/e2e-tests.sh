#!/bin/bash -e

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

echo "Run sonobuoy Kubernetes e2e tests"
echo "Running e2e tests"

# Delete previous test
sonobuoy delete --all --wait

# Long test
# sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --wait

# Quick test
sonobuoy run --mode quick --wait

# Get results
results=$(sonobuoy retrieve)
sonobuoy results $results
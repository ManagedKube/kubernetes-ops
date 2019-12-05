#!/bin/bash -ex

echo "Run sonobuoy Kubernetes e2e tests"
echo "Running e2e tests"

# Long test
# sonobuoy run --e2e-focus="\\[Conformance\\]" --e2e-skip="(\[Serial\])" --mode quick --wait

# Quick test
sonobuoy run --mode quick --wait

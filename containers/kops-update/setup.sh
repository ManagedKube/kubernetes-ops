#!/bin/bash -e

KOPS_VERSION=1.14.1
SONOBUOY_VERSION=0.15.3

KOPS_BINARY="https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64"
SONOBUOY_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/"
SONOBUOY_TAR_FILE="sonobuoy_${SONOBUOY_VERSION}_linux_amd64"

echo "Setup ubuntu"
apt-get update && apt-get install -y curl

echo "Setup kops"
curl -o kops --location ${KOPS_BINARY}
chmod u+x ./kops
cp ./kops /usr/local/bin/
kops version

echo "Setup sonobuoy"
curl -o ${SONOBUOY_TAR_FILE}.tar.gz --location ${SONOBUOY_URL}/${SONOBUOY_TAR_FILE}.tar.gz
tar -zxvf ${SONOBUOY_TAR_FILE}.tar.gz
cp ./sonobuoy /usr/local/bin/
sonobuoy version

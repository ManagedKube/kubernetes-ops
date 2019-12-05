#!/bin/bash -e

KOPS_BINARY="https://github.com/kubernetes/kops/releases/download/1.13.2/kops-linux-amd64"
SONOBUOY_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.14.3/"
SONOBUOY_TAR_FILE="sonobuoy_0.14.3_linux_amd64"

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

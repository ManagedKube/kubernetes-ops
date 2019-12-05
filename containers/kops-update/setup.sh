#!/bin/bash -ex

KUBECTL_VERSION=v1.16.0
KOPS_VERSION=1.14.1
SONOBUOY_VERSION=0.14.3

KUBECTL_BINARY="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
KOPS_BINARY="https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64"
SONOBUOY_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}/sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"

echo "Setup ubuntu"
apt-get update && apt-get install -y curl

echo "Setup kubectl"
curl -LO ${KUBECTL_BINARY}
chmod 755 kubectl
cp kubectl /usr/local/bin/
kubectl version

echo "Setup kops"
curl -o kops --location ${KOPS_BINARY}
chmod u+x ./kops
cp ./kops /usr/local/bin/
kops version

echo "Setup sonobuoy"
curl -o sonobuoy.tar.gz --location ${SONOBUOY_URL}
tar -zxvf sonobuoy.tar.gz
cp ./sonobuoy /usr/local/bin/
sonobuoy version

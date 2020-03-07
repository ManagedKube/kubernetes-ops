HELM_BINARY?=helm
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=fluxcd

BASE_PATH=.

APPLCATION_CHART_NAME=./
APPLICATION_NAME=flux
# VERSION=0.11

dependency:
	${HELM_BINARY} dependency build

apply-crd:
	kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-${VERSION}/deploy/manifests/00-crds.yaml

delete-crd:
	kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-${VERSION}/deploy/manifests/00-crds.yaml

apply:
	${HELM_BINARY} upgrade -i ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/environments/${ENVIRONMENT}/values.yaml

template:
	${HELM_BINARY} template ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/environments/${ENVIRONMENT}/values.yaml

delete:
	${HELM_BINARY} --namespace ${KUBE_NAMESPACE} delete ${APPLICATION_NAME}

list:
	${HELM_BINARY} --namespace ${KUBE_NAMESPACE} list

dependency-build:
	${HELM_BINARY} dependency build

add-repository:
	${HELM_BINARY} repo add fluxcd https://charts.fluxcd.io

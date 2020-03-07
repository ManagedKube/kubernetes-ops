HELM_BINARY?=helm
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=fluxcd

BASE_PATH=.

APPLCATION_CHART_NAME=./
APPLICATION_NAME=helm-operator
# CRD_VERSION=1.0.0

dependency:
	${HELM_BINARY} dependency build

# This CRD should be versioned once they get to 1.0.0
apply-crd:
	kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

delete-crd:
	kubectl delete -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

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

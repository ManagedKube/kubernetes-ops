HELM_BINARY?=helm
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=cert-manager

BASE_PATH=.

APPLCATION_CHART_NAME=./
# APPLCATION_CHART_NAME=jetstack/cert-manager
APPLICATION_NAME=cert-manager
VERSION=v0.14.0

VALUES_FILE?=values.yaml

TEMPLATE_OUTPUT_FILE?=./helm-output.yaml

dependency:
	${HELM_BINARY} dependency build

apply-crd:
	kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-${VERSION}/deploy/manifests/00-crds.yaml

delete-crd:
	kubectl delete -f https://raw.githubusercontent.com/jetstack/cert-manager/release-${VERSION}/deploy/manifests/00-crds.yaml

apply:
	${HELM_BINARY} upgrade -i ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${VALUES_FILE}

template:
	${HELM_BINARY} template ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${VALUES_FILE}

delete:
	${HELM_BINARY} --namespace ${KUBE_NAMESPACE} delete ${APPLICATION_NAME}

list:
	${HELM_BINARY} list

dependency-build:
	${HELM_BINARY} dependency build

add-repository:
	${HELM_BINARY} repo add jetstack https://charts.jetstack.io

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
	${HELM_BINARY} template \
	--name cert-manager \
	--namespace ${KUBE_NAMESPACE} \
	--name ${KUBE_NAMESPACE}-${APPLICATION_NAME} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	${APPLCATION_CHART_NAME} > ${TEMPLATE_OUTPUT_FILE}
	kubectl apply -f ${TEMPLATE_OUTPUT_FILE}

template:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	${APPLCATION_CHART_NAME}

delete:
	${HELM_BINARY} template \
	--name cert-manager \
	--namespace ${KUBE_NAMESPACE} \
	--name ${KUBE_NAMESPACE}-${APPLICATION_NAME} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	${APPLCATION_CHART_NAME} > ${TEMPLATE_OUTPUT_FILE}
	kubectl delete -f ${TEMPLATE_OUTPUT_FILE}

list:
	${HELM_BINARY} list

dependency-build:
	${HELM_BINARY} dependency build

add-repository:
	${HELM_BINARY} repo add jetstack https://charts.jetstack.io

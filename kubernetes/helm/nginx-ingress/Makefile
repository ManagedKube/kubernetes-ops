HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=ingress

APPLICATION_NAME=nginx-ingress

BASE_PATH=.

APPLCATION_CHART_NAME=stable/nginx-ingress

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=values-${ENVIRONMENT}.yaml

TEMPLATE_OUTPUT_FILE?=./templated-output.yaml

apply:
	${HELM_BINARY} upgrade -i ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${VALUES_FILE}

template:
	${HELM_BINARY} template ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${VALUES_FILE}

delete:
	${HELM_BINARY} delete ${APPLICATION_NAME}

build-dependency:
	${HELM_BINARY} dependency build

list:
	${HELM_BINARY} list

internal-template:
	make APPLICATION_NAME=internal VALUES_FILE=environments/${ENVIRONMENT}/values-internal.yaml template

internal-apply:
	make APPLICATION_NAME=internal VALUES_FILE=environments/${ENVIRONMENT}/values-internal.yaml apply

internal-delete:
	make APPLICATION_NAME=internal VALUES_FILE=environments/${ENVIRONMENT}/values-internal.yaml delete

external-template:
	make APPLICATION_NAME=external VALUES_FILE=environments/${ENVIRONMENT}/values-external.yaml template

external-apply:
	make APPLICATION_NAME=external VALUES_FILE=environments/${ENVIRONMENT}/values-external.yaml apply

external-delete:
	make APPLICATION_NAME=external VALUES_FILE=environments/${ENVIRONMENT}/values-external.yaml delete

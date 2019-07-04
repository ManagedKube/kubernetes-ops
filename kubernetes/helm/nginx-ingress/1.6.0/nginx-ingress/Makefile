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
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--name ${APPLICATION_NAME} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	./ > ${TEMPLATE_OUTPUT_FILE}
	kubectl --namespace ${KUBE_NAMESPACE} apply -f ${TEMPLATE_OUTPUT_FILE}

template:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--name ${APPLICATION_NAME} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	./

delete:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--name ${APPLICATION_NAME} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	./ > ${TEMPLATE_OUTPUT_FILE}
	kubectl --namespace ${KUBE_NAMESPACE} delete -f ${TEMPLATE_OUTPUT_FILE}

build-dependency:
	helm dependency build

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

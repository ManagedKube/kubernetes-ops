HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=external-dns
APPLICATION_NAME?=external-dns

NAME?=external-dns

BASE_PATH=.

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=values-${ENVIRONMENT}.yaml

TEMPLATE_OUTPUT_FILE?=/tmp/output.yaml

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
	${HELM_BINARY} dependency build

list:
	${HELM_BINARY} list

domain-top-level-template:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-top-level.yaml template

domain-local-env-template:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-local-env.yaml template

domain-top-level-apply:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-top-level.yaml apply

domain-local-env-apply:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-local-env.yaml apply

domain-top-level-delete:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-top-level.yaml delete

domain-local-env-delete:
	make ENVIRONMENT=${ENVIRONMENT} VALUES_FILE=./environments/${ENVIRONMENT}/values-domain-local-env.yaml delete

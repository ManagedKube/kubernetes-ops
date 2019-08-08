HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=jenkins
APPLICATION_NAME?=jenkins

NAME?=jenkins

BASE_PATH=.

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=values-${ENVIRONMENT}.yaml

TEMPLATE_OUTPUT_FILE?=./output.yaml

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

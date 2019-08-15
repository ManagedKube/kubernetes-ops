HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=cert-manager

AWS_ACCESS_KEY_ID?=xxx
AWS_SECRET_ACCESS_KEY?=xxx

BASE_PATH=.

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=environments/${ENVIRONMENT}/values.yaml

TEMPLATE_OUTPUT_FILE?=./templated-output.yaml

apply:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	--set aws.accessKeyID=${AWS_ACCESS_KEY_ID} \
	--set aws.accessSecret=${AWS_SECRET_ACCESS_KEY} \
	./ > ${TEMPLATE_OUTPUT_FILE}
	kubectl --namespace ${KUBE_NAMESPACE} apply -f ${TEMPLATE_OUTPUT_FILE}

template:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	--set aws.accessKeyID=${AWS_ACCESS_KEY_ID} \
	--set aws.accessSecret=${AWS_SECRET_ACCESS_KEY} \
	./

delete:
	${HELM_BINARY} template \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE} \
	./ > ${TEMPLATE_OUTPUT_FILE}
	kubectl --namespace ${KUBE_NAMESPACE} delete -f ${TEMPLATE_OUTPUT_FILE}

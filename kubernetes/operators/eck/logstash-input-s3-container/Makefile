HELM_BINARY?=helm
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=app

UNIT_NAME?=logstash-s3-input-flowlog

BASE_VALUES_FILE=values.yaml
VALUES_FILE?=environments/${ENVIRONMENT}/values.yaml

TEMPLATE_OUTPUT=./templated-output.yaml

template:
	${HELM_BINARY} template \
	--name ${UNIT_NAME} \
	--namespace ${KUBE_NAMESPACE} \
	--values ./${BASE_VALUES_FILE} \
	--values ./${VALUES_FILE} .

apply:
	${HELM_BINARY} template \
	--name ${UNIT_NAME} \
	--namespace ${KUBE_NAMESPACE} \
	--values ./${BASE_VALUES_FILE} \
	--values ./${VALUES_FILE} . > ${TEMPLATE_OUTPUT}
	kubectl apply -f ${TEMPLATE_OUTPUT}

delete:
	${HELM_BINARY} template \
	--name ${UNIT_NAME} \
	--namespace ${KUBE_NAMESPACE} \
	--values ./${BASE_VALUES_FILE} \
	--values ./${VALUES_FILE} . > ${TEMPLATE_OUTPUT}
	kubectl delete -f ${TEMPLATE_OUTPUT}

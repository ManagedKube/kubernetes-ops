HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=monitoring

APPLICATION_NAME=prometheus-blackbox-exporter

BASE_PATH=.

APPLCATION_CHART_NAME=stable/prometheus-blackbox-exporter

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=values.yaml

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

servicemonitor-template:
	cat environments/${ENVIRONMENT}/servicemonitor.yaml

servicemonitor-apply:
	kubectl --namespace ${KUBE_NAMESPACE} apply -f environments/${ENVIRONMENT}/servicemonitor.yaml

servicemonitor-delete:
	kubectl --namespace ${KUBE_NAMESPACE} delete -f environments/${ENVIRONMENT}/servicemonitor.yaml

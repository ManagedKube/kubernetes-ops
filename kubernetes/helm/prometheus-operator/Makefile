HELM_BINARY?=helm
KUBECTL_BINARY?=kubectl
KUBECONFIG?=~/.kube/config
KUBE_NAMESPACE?=monitoring

APPLICATION_NAME=prometheus-operator

BASE_PATH=.

APPLCATION_CHART_NAME=stable/prometheus-operator

BASE_VALUES_FILE?=values.yaml
VALUES_FILE?=environments/${ENVIRONMENT}/values.yaml

TEMPLATE_OUTPUT_FILE?=/tmp/output.yaml

apply:
	${HELM_BINARY} upgrade -i ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE}

template:
	${HELM_BINARY} template ${APPLICATION_NAME} ./ --wait \
	--namespace ${KUBE_NAMESPACE} \
	--values ${BASE_PATH}/${BASE_VALUES_FILE} \
	--values ${BASE_PATH}/${VALUES_FILE}

delete:
	${HELM_BINARY} -n ${KUBE_NAMESPACE} delete ${APPLICATION_NAME}

delete-crd:
	# CRDs are added on install by default: `prometheusOperator.createCustomResource`
	# https://github.com/helm/charts/tree/master/stable/prometheus-operator#uninstalling-the-chart
	${KUBECTL_BINARY} delete crd prometheuses.monitoring.coreos.com
	${KUBECTL_BINARY} delete crd prometheusrules.monitoring.coreos.com
	${KUBECTL_BINARY} delete crd servicemonitors.monitoring.coreos.com
	${KUBECTL_BINARY} delete crd podmonitors.monitoring.coreos.com
	${KUBECTL_BINARY} delete crd alertmanagers.monitoring.coreos.com

dependency-build:
	${HELM_BINARY} dependency build

list:
	${HELM_BINARY} list

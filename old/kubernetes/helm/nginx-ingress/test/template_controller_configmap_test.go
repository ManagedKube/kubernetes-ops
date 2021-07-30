package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	corev1 "k8s.io/api/core/v1"
)

func TestControllerConfigmapTemplateRendersProxyBodySize(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../"

	// Setup the args
	options := &helm.Options{
		SetValues: map[string]string{
			"nginx-ingress.controller.config.proxy-body-size": "8m",
		},
	}

	releaseName := "nginx-ingress"

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"charts/nginx-ingress/templates/controller-configmap.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the struct.
	var configmap corev1.ConfigMap
	helm.UnmarshalK8SYaml(t, output, &configmap)

	// // Verify the spec is set to the expected value
	expectedValue := "8m"
	cm := configmap.Data
	if cm["proxy-body-size"] != expectedValue {
		t.Fatalf("Rendered container image (%s) is not expected (%s)", cm["proxy-body-size"], expectedValue)
	}

}

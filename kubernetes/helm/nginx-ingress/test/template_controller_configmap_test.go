package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	corev1 "k8s.io/api/core/v1"
)

func TestControllerConfigmapTemplateRendersProxyBodySize(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../"

	// Setup the args. For this test, we will set the following input values:
	// - image=nginx:1.15.8
	options := &helm.Options{
		SetValues: map[string]string{
			"nginx-ingress.controller.config.proxy-body-size": "8m",
		},
	}

	releaseName := "nginx-ingress"

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"charts/nginx-ingress/templates/controller-configmap.yaml"})
	// output := helm.RenderTemplate(t, options, helmChartPath, helmChartPath, []string{})

	// Now we use kubernetes/client-go library to render the template output into the Pod struct. This will
	// ensure the Pod resource is rendered correctly.
	var configmap corev1.ConfigMap
	helm.UnmarshalK8SYaml(t, output, &configmap)

	// // Finally, we verify the pod spec is set to the expected container image value
	expectedValue := "8m"
	fmt.Print(expectedValue)
	cm := configmap.Data
	if cm["proxy-body-size"] != expectedValue {
		t.Fatalf("Rendered container image (%s) is not expected (%s)", cm["proxy-body-size"], expectedValue)
	}

}

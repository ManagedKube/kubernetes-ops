package test

import (
	"testing"

	appsv1 "k8s.io/api/apps/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

func TestDeploymentTemplateRendersContainerImage(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../"

	// Setup the args. For this test, we will set the following input values:
	// - image=nginx:1.15.8
	options := &helm.Options{
		SetValues: map[string]string{
			"nginx-ingress.controller.image.repository": "quay.io/kubernetes-ingress-controller/nginx-ingress-controller",
			"nginx-ingress.controller.image.tag":        "0.30.0",
		},
	}

	releaseName := "nginx-ingress"

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"charts/nginx-ingress/templates/controller-deployment.yaml"})
	//output := helm.RenderTemplate(t, options, helmChartPath, helmChartPath, []string{})

	// Now we use kubernetes/client-go library to render the template output into the Pod struct. This will
	// ensure the Pod resource is rendered correctly.
	var deployment appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deployment)

	// Finally, we verify the pod spec is set to the expected container image value
	expectedContainerImage := "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0"
	podContainers := deployment.Spec.Template.Spec.Containers
	if podContainers[0].Image != expectedContainerImage {
		t.Fatalf("Rendered container image (%s) is not expected (%s)", podContainers[0].Image, expectedContainerImage)
	}

}

func TestDeploymentTemplateRendersServiceAccountName(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../"

	// Setup the args. For this test, we will set the following input values:
	// - image=nginx:1.15.8
	options := &helm.Options{
		SetValues: map[string]string{},
	}

	releaseName := "nginx-ingress"

	// Run RenderTemplate to render the template and capture the output.
	output := helm.RenderTemplate(t, options, helmChartPath, releaseName, []string{"charts/nginx-ingress/templates/controller-deployment.yaml"})
	//output := helm.RenderTemplate(t, options, helmChartPath, helmChartPath, []string{})

	// Now we use kubernetes/client-go library to render the template output into the Pod struct. This will
	// ensure the Pod resource is rendered correctly.
	var deployment appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deployment)

	// Finally, we verify the pod spec is set to the expected container image value
	expectedServiceAccountName := "nginx-ingress"
	deploymentSpec := deployment.Spec.Template.Spec
	if deploymentSpec.ServiceAccountName != expectedServiceAccountName {
		t.Fatalf("Rendered container image (%s) is not expected (%s)", deploymentSpec.ServiceAccountName, expectedServiceAccountName)
	}

}

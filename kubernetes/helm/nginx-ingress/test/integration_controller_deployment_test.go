package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
)

func TestPodDeploysContainerImageHelmTemplateEngine(t *testing.T) {
	// Path to the helm chart we will test
	helmChartPath := "../"

	// To ensure we can reuse the resource config on the same cluster to test different scenarios, we setup a unique
	// namespace for the resources for this test.
	// Note that namespaces must be lowercase.
	namespaceName := fmt.Sprintf("kubernetes-ops-integration-test-nginx-ingress-%s", strings.ToLower(random.UniqueId()))

	// Setup the kubectl config and context. Here we choose to use the defaults, which is:
	// - HOME/.kube/config for the kubectl config file
	// - Current context of the kubectl config file
	kubectlOptions := k8s.NewKubectlOptions("", "", namespaceName)

	// Create a namespace for this test deployment
	k8s.CreateNamespace(t, kubectlOptions, namespaceName)

	// Delete the namespace at the end of the test
	defer k8s.DeleteNamespace(t, kubectlOptions, namespaceName)

	// Setup the args
	// We use a fullnameOverride so we can find the Pod later during verification
	releaseName := fmt.Sprintf("nginx-ingress-test-%s", strings.ToLower(random.UniqueId()))
	options := &helm.Options{
		SetValues: map[string]string{
			"nginx-ingress.controller.image.repository": "quay.io/kubernetes-ingress-controller/nginx-ingress-controller",
			"nginx-ingress.controller.image.tag":        "0.30.0",
			"fullnameOverride":                          releaseName,
		},
		KubectlOptions: kubectlOptions,
	}

	// Helm install the chart
	helm.Install(t, options, helmChartPath, releaseName)

	// Delete the resources at the end of the test
	defer helm.Delete(t, options, releaseName, false)

	// Now that the chart is deployed, verify the deployment. This function will open a tunnel to the Pod and hit the
	// nginx container endpoint.
	// verifyNginxPod(t, kubectlOptions, podName)
}

// verifyNginxPod will open a tunnel to the Pod and hit the endpoint to verify the nginx welcome page is shown.
// func verifyNginxPod(t *testing.T, kubectlOptions *k8s.KubectlOptions, podName string) {
// 	// Wait for the pod to come up. It takes some time for the Pod to start, so retry a few times.
// 	retries := 15
// 	sleep := 5 * time.Second
// 	k8s.WaitUntilPodAvailable(t, kubectlOptions, podName, retries, sleep)

// 	// We will first open a tunnel to the pod, making sure to close it at the end of the test.
// 	tunnel := k8s.NewTunnel(kubectlOptions, k8s.ResourceTypePod, podName, 0, 80)
// 	defer tunnel.Close()
// 	tunnel.ForwardPort(t)

// 	// ... and now that we have the tunnel, we will verify that we get back a 200 OK with the nginx welcome page.
// 	// It takes some time for the Pod to start, so retry a few times.
// 	endpoint := fmt.Sprintf("http://%s", tunnel.Endpoint())
// 	http_helper.HttpGetWithRetryWithCustomValidation(
// 		t,
// 		endpoint,
// 		nil,
// 		retries,
// 		sleep,
// 		func(statusCode int, body string) bool {
// 			return statusCode == 200 && strings.Contains(body, "Welcome to nginx")
// 		},
// 	)
// }

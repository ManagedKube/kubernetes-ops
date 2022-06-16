# Progress on the terragrunt-dev env

# Created

## Pipelines
* PR plan pipeline and apply on merge
* Destroy pipeline

## Base infrastructure
* 050-github-aws-permissions 
* 150-route53-hostedzone     
* 100-vpc
* 200-eks
* 250-eks-cluster-autoscaler environment.hcl
* 300-kubernetes

## Kubernetes items
* 10-cert-manager
* 20-testkube
* 30-testkube-test-suites


## Todo:
* external-dns
* external-secrets
* istio
* kube-prometheus-stack
* grafana-loki
* opentelemetry

* Sample app that will push data into opentelemetry
* CloudWatch Alarms and CloudTrail (S3)


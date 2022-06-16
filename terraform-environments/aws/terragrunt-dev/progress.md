# Progress on the terragrunt-dev env

# Created

## Pipelines

## PR plan pipeline and apply on merge

## Destroy pipeline
Example of the destroy pipeline running:
* Wanted to rename the istio directory so I had to delete it first
* https://github.com/ManagedKube/kubernetes-ops/runs/6912249701?check_suite_focus=true

## Base infrastructure
* 050-github-aws-permissions 
* 150-route53-hostedzone     
* 100-vpc
* 200-eks
* 250-eks-cluster-autoscaler environment.hcl
* 300-kubernetes

## Kubernetes items
### Testing
* 100-testkube
* 110-testkube-test-suites

### Infrastructure support
* 200-external-dns
* 210-external-secrets
* 220-cert-manager

### Infrastructure
* 300-istio
* 310-kube-prometheus-stack
* 320-grafana-loki
* 330-opentelemetry

### Applications
* 500-app-that-pushes metrics to opentelemetry

# Todo
* CloudWatch Alarms and CloudTrail (S3)


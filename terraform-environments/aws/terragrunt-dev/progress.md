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

### Infrastructure support
* 100-cert-manager
* 110-testkube
* 120-external-dns
* 130-external-secrets


### Infrastructure
* 200-istio
* 210-kube-prometheus-stack
* 220-grafana-loki
* 230-opentelemetry

### Applications
* 500-app-that-pushes metrics to opentelemetry

# Todo
* CloudWatch Alarms and CloudTrail (S3)


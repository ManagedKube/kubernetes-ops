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
* 100-route53-hostedzone     
* 150-vpc
* 200-eks
* 250-eks-cluster-autoscaler

## Kubernetes items
* 300-kubernetes - are in this folder

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


# Notes

## Terragrunt none interactive flag

The terragrunt init was complaining about the S3 backend store not being up to date and wanted to update it and asked the user to hit y/n.  Being in a pipeline this fails immediately b/c there is no one there to say yes or no:

```
time=2022-06-16T19:33:59Z level=warning msg=The remote state S3 bucket terraform-state-***-us-east-1-terragrunt-dev needs to be updated: prefix=[/github/workspace/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev/100-route53-hostedzone] 
time=2022-06-16T19:33:59Z level=warning msg=  - Bucket Server-Side Encryption prefix=[/github/workspace/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev/100-route53-hostedzone] 
time=2022-06-16T19:33:59Z level=warning msg=  - Bucket Root Access prefix=[/github/workspace/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev/100-route53-hostedzone] 
time=2022-06-16T19:33:59Z level=warning msg=  - Bucket Enforced TLS prefix=[/github/workspace/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev/100-route53-hostedzone] 
Remote state S3 bucket terraform-state-***-us-east-1-terragrunt-dev is out of date. Would you like Terragrunt to update it? (y/n) time=2022-06-16T19:33:59Z level=error msg=EOF
time=2022-06-16T19:33:59Z level=error msg=Unable to determine underlying exit code, so Terragrunt will exit with error code 1
```

The last commit was to add the "non interactive" flag so that it just said yes.  Will probably take this flag out of the pipeline after this.

```yaml
      - name: 'Terragrunt Init'
        uses: the-commons-project/terragrunt-github-actions@master
        with:
          tf_actions_version: ${{ env.tf_version }}
          tg_actions_version: ${{ env.tg_version }}
          tf_actions_cli_credentials_token: ${{ secrets.TF_API_TOKEN_DEV }}
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: ${{ env.tf_working_dir }}
          args: --terragrunt-non-interactive
          tf_actions_comment: true
```


https://github.com/ManagedKube/kubernetes-ops/pull/317#issuecomment-1158068550

## 100-route53-hostedzone
It turns out that if you have a subdomain when creating this hostedzone the apply would fail
because it is trying to setup DNSSEC and trying to validate it.  Prior to adding the DNS nameservers
from creating this hostedzone to the parent zone, it will not be able to validate it which in
turns makes this route53 creation fail:

```
╷
│Error: error enabling Route 53 Hosted Zone DNSSEC (Z056815334Y63ULFJ8RDG): error enabling: HostedZonePartiallyDelegated: Due to DNS lookup failure, we cannot determine if hosted zone with ID 'Z056815334Y63ULFJ8RDG' has NS records partially connected with its parent zone. Please retry later.
│	status code: 400, request id: 0d05ce71-5e01-4628-b4c2-cfca1ba6410f
│
│  with aws_route53_hosted_zone_dnssec.this,
│  on main.tf line 62, in resource "aws_route53_hosted_zone_dnssec" "this":
│  62: resource "aws_route53_hosted_zone_dnssec" "this" {
│
╵
time=2022-06-16T19:50:47Z level=error msg=1 error occurred:
	* exit status 1
```
GHA run: https://github.com/ManagedKube/kubernetes-ops/runs/6925224762?check_suite_focus=true#step:11:185

This probably should be split into more than one module/instantiation:
1. Create the route53 hosted zone
1. With the output of the hosted zone's NS records add it to the parent zone (which might be in another AWS account).  Which makes this harder to do
1. Update this hosted zone to enable DNSSEC

# 150-vpc

Went fine: https://github.com/ManagedKube/kubernetes-ops/pull/318

# 200-eks

PR: https://github.com/ManagedKube/kubernetes-ops/pull/319
* I just touched the file since it was already in the repository to make the pipeline create it all again

# 250-eks-cluster-autoscaler

PR: https://github.com/ManagedKube/kubernetes-ops/pull/320

# 100-cert-manager




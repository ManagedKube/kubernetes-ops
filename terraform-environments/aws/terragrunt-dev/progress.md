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

Then subsequently, I saw that AWS EKS module that we are using now supports (again) the kubernetes
auth configmap: https://github.com/terraform-aws-modules/terraform-aws-eks

```
  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
```

They took this out before because the AWS EKS module said they didnt want to take care of this and
was out of scope for this module.  I guess they changed their minds which is good b/c this was
a pain for the user of this module to take care of it on their own.

Updating our usage of the module to use this again PR: https://github.com/ManagedKube/kubernetes-ops/pull/322

Another note.  You might be wondering why we dont just use the source AWS EKS module directly.  That is
a good question.  The reason is b/c that module needs stuff like the AWS KMS keys resources.  We are "wrapping"
our module around theirs so that it takes care of all of this for the end user.  You can think of the AWS EKS
module and a primitive like an int/map/etc.  This kubernetes-ops module you are using is like a "function" that
takes those primitives and adds other stuff to it to make it easier for the end user to use for this specific
use case.

PR for testing out using that updated module: https://github.com/ManagedKube/kubernetes-ops/pull/323
* Looks good!
* Auth is working as well for the user that created the cluster and my local user


PR for setting the 200-eks terragrunt to the release tag: https://github.com/ManagedKube/kubernetes-ops/pull/324
* It was on the branch for the module before so that I can test it out without having to merge and release the eks updated module

# 100-cert-manager
TestKube is dependent on cert-manager for it's internal usage

Cert manager was failing:

```
 │Error: Failed to determine GroupVersionResource for manifest
│
│  with kubernetes_manifest.dns01_cluster_issuer[0],
│  on main.tf line 107, in resource "kubernetes_manifest" "dns01_cluster_issuer":
│ 107: resource "kubernetes_manifest" "dns01_cluster_issuer" {
│
│no matches for kind "ClusterIssuer" in group "cert-manager.io"
╵
╷
│Error: Failed to determine GroupVersionResource for manifest
│
│  with kubernetes_manifest.http01_cluster_issuer[0],
│  on main.tf line 131, in resource "kubernetes_manifest" "http01_cluster_issuer":
│ 131: resource "kubernetes_manifest" "http01_cluster_issuer" {
│
│no matches for kind "ClusterIssuer" in group "cert-manager.io"
╵
time=2022-06-16T22:56:58Z level=error msg=1 error occurred:
	* exit status 1
```

The cert-manager module does have a wait for the cert-manager helm chart to be installed first
then this error is trying to apply the cert-manager's CRDs for the ClusterIssuer which tells
cert-manager how you want to validate the Let's Encrypt certs like use the DNS and add a record there.


Reading the `kubernetes_manifest` doc: 

https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest

Right at the top it does say that this will access to your kube API and try this out even
during the plan stage.  This is why it is failing.  This behavior did change b/c this module
was working before.

The idea now is to separate out the cert-manager helm chart install and then have another
module to apply the cert-manager's issuers.

The PR to separate this out to two modules:https://github.com/ManagedKube/kubernetes-ops/pull/326

This PR: https://github.com/ManagedKube/kubernetes-ops/pull/327
* Applies the cert-manager helm install
* no issuers

This PR: https://github.com/ManagedKube/kubernetes-ops/pull/328
* Applies the cert-manager-issuer items


# 110-testkube

PR: https://github.com/ManagedKube/kubernetes-ops/pull/329

# 110-testkube-infra-base

PR: https://github.com/ManagedKube/kubernetes-ops/pull/330

These are basic test that can apply to any cluster provided by ManagedKube

# 110-testkube-local
This is an example on how to structure your testkube so that you can use the kubernetes-ops `base-tests`
and have your own `local` tests (this directory).  While this `local` directory resides in this kubernetes-ops
repo, it is really meant to go into your own repo and you can reference the source from there.  The reason
is that the set of tests here in this module is specific to you and really to no one else.

PR: https://github.com/ManagedKube/kubernetes-ops/pull/331
* Has the local module with the testkube (which should be in your own repo instead of this one)
* Instantiation of that module to apply the testkube CRDs (test and testsuites)
  * You will need to change the `source` of this module to your own repo

# gha-testkube-run
Now that we have testkube in.  We can test run it to check if it is working.



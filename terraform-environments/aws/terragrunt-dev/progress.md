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

PR: https://github.com/ManagedKube/kubernetes-ops/pull/332
* The test fails but that is known since it is hitting a currently none existent endpoint
* The point of this was to check if it is running and if you look at the PR and look at the runs you can see testkube running successfully
* Commenting out the testkube run for now


# 120-external-dns

PR: https://github.com/ManagedKube/kubernetes-ops/pull/334

Failed to apply:
* https://github.com/ManagedKube/kubernetes-ops/actions/runs/2517587090

PR to investigate and to fix this:
* https://github.com/ManagedKube/kubernetes-ops/pull/335
* The last commit commented out the `if` statement in the GHA pipeline so that it will apply without having to merge this PR first.  This is a way to test if it is working.  You probably should only do this in a dev type env.
* Turns out that the problem was not the external-dns helm chart

The problem:
It turns out that the Terraform helm provider just updated from version `2.5.1` to `2.6.0`.

Was searching around the internet for this error in the GHA run:
```
 │Error: Kubernetes cluster unreachable: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
```

Nothing that directly told me a fix but people were eluding to versions of kubectl and helm and maybe
even aws cli.  I dont specifically set that but I do provide the helm version through the Terraform helm
provider.

Looking at a recent run of the `10-cert-manager`'s `.terraform.lock.file` and indeed the versions
changed.  So I made this change to use the older version to see if it would work: 
* https://github.com/ManagedKube/kubernetes-ops/pull/335/files#diff-e64319124f37bef2c05ed3a1916e4b0c58cd6616e36091d00e2a77a3618427caR23

After making this change:
* The apply run went fine:
* https://github.com/ManagedKube/kubernetes-ops/runs/6942225637?check_suite_focus=true

This is a good lesson that teaches us the following:
* It is important to use the `.terraform.lock.hcl` file
* Sometimes it is not our fault.  We use a lot of open source items here and are dependent on a lot of other
upstream items that have their own life cycle and releases.  While we dont want to lock all versions and fork every single thing that we use because it would just be too much for us to maintain, we can lock/peg some versions to help us control this ever changing world we live in.


# 130-external-secrets
This installs the external-secrets helm chart which is an operator

PR: https://github.com/ManagedKube/kubernetes-ops/pull/336

Looks like this also has the same helm provider version problem
* https://github.com/ManagedKube/kubernetes-ops/runs/6943822623?check_suite_focus=true

Will have to peg all new ones to the older version for now.
* https://github.com/ManagedKube/kubernetes-ops/pull/337

# 130-external-secrets-store
This installs the CRDs for external-secrets to tell it what AWS secret store
to use.

PR: https://github.com/ManagedKube/kubernetes-ops/pull/338

# 200-istio

PR: https://github.com/ManagedKube/kubernetes-ops/pull/339
* failed b/c of the lock file

PR: https://github.com/ManagedKube/kubernetes-ops/pull/340
* Updated the lock file

# 200-istio cert

PR: https://github.com/ManagedKube/kubernetes-ops/pull/345

This gets the cert-manager/Let's Encrypt wild card cert that
can be used for all namespaces.

For example the kube prometheus stack will reference the secret
name created here:

```yaml
grafana:
  adminPassword: prom-operator
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: istio
    hosts:
    - grafana.${domain_name}
    tls:
    - hosts:
      - grafana.${domain_name} # This should match a DNS name in the Certificate
      # Istio doc: https://istio.io/latest/docs/ops/integrations/certmanager/#kubernetes-ingress
      # If using istio and using the domain-wildcard cert, the cert-manager kind: certificate
      # should be created in the istio-system namespace.
      secretName: domain-wildcard # This should match the Certificate secretName
```

This will get a wild card certificate for the entire cluster to use.  In most cases just
getting this one certificate would be good enough.

# 210-kube-prometheus-stack

PR: https://github.com/ManagedKube/kubernetes-ops/pull/343

Can reach grafana at this URL: https://grafana.terragrunt-dev.managedkube.com

# enabling testkube

PR: https://github.com/ManagedKube/kubernetes-ops/pull/346

We added testkube deployments into the cluster above but it was disabled b/c the initial
test was testing to see if the prometheus endpoint was up or not.  Now that it is,
we can enable it so that it would actually pass.

The testkube stuff seems broken right now.  Im not able to get the testkube items for
some reason:

```
kubectl testkube get tests
⨯ setting up client type (error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1")
```

It might be because of the kube version of the client or the server?

Going to skip this for now.

# 220-grafana-loki

PR: https://github.com/ManagedKube/kubernetes-ops/pull/348

# 230-opentelemetry

PR: https://github.com/ManagedKube/kubernetes-ops/pull/349
* This is for the tempo server

# 230-opentelemetry operator

PR: https://github.com/ManagedKube/kubernetes-ops/pull/350
* This is for the operator that will setup the opentel collector

# 230-opentelemetry collector

PR: https://github.com/ManagedKube/kubernetes-ops/pull/351
* Applies the opentelemetry CRD to create a collector
* This collector sends its outputs to the tempo server

# 500-sample-app opentelemetry - 1
This is an example application that uses:
* The Generic Application helm chart to easily deploy any docker container
* The application that this deploys is the opentelemetry's example application
  which has a frontend and a backend.  It will send the APM traces to the 
  opentelemetry collector which then can be visualized in Grafana.

PR: https://github.com/ManagedKube/kubernetes-ops/pull/352

This is also a good example of using the ManagedKube's Generic Application
Helm chart to deploy out any containers that we find out there.

# istio DNS star route
Instead of adding each individual domain name in for external-dns to setup
we can add in a *.${domain_name} route then it would slurp everything in.

PR: https://github.com/ManagedKube/kubernetes-ops/pull/353

Once this was applied...looking at the external-dns logs:

```
time="2022-06-28T22:30:48Z" level=info msg="Applying provider record filter for domains: [terragrunt-dev.managedkube.com. .terragrunt-dev.managedkube.com.]"
time="2022-06-28T22:30:49Z" level=info msg="Desired change: CREATE *.terragrunt-dev.managedkube.com A [Id: /hostedzone/Z056815334Y63ULFJ8RDG]"
time="2022-06-28T22:30:49Z" level=info msg="Desired change: CREATE *.terragrunt-dev.managedkube.com TXT [Id: /hostedzone/Z056815334Y63ULFJ8RDG]"
time="2022-06-28T22:30:49Z" level=info msg="2 record(s) in zone terragrunt-dev.managedkube.com. [Id: /hostedzone/Z056815334Y63ULFJ8RDG] were successfully updated"
```

We can see the records are created.

Testing it out to make sure it is resolving:

```
dig foobar.terragrunt-dev.managedkube.com 

; <<>> DiG 9.10.6 <<>> foobar.terragrunt-dev.managedkube.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 55064
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;foobar.terragrunt-dev.managedkube.com. IN A

;; ANSWER SECTION:
foobar.terragrunt-dev.managedkube.com. 60 IN A  52.206.197.145
foobar.terragrunt-dev.managedkube.com. 60 IN A  54.152.224.149

;; Query time: 99 msec
;; SERVER: 192.168.86.1#53(192.168.86.1)
;; WHEN: Tue Jun 28 15:31:48 PDT 2022
;; MSG SIZE  rcvd: 98
```

# 510-sample-app-opentel-2
Second sample app that has opentelemetry tracing enabled

PR: https://github.com/ManagedKube/kubernetes-ops/pull/354

Was having a problem getting sub pages that are required for the entire page to load.
In the web browser it was saing that it was not able to get: `https://sample-app-2.terragrunt-dev.managedkube.com/jquery-3.1.1.min.js`

Trying it out in cURL shows the same things.


```bash
curl https://sample-app-2.terragrunt-dev.managedkube.com/jquery-3.1.1.min.js -v               
*   Trying 54.152.224.149:443...
* Connected to sample-app-2.terragrunt-dev.managedkube.com (54.152.224.149) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*  CAfile: /etc/ssl/cert.pem
*  CApath: none
* (304) (OUT), TLS handshake, Client hello (1):
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-AES256-GCM-SHA384
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=*.terragrunt-dev.managedkube.com
*  start date: Jun 23 22:56:41 2022 GMT
*  expire date: Sep 21 22:56:40 2022 GMT
*  subjectAltName: host "sample-app-2.terragrunt-dev.managedkube.com" matched cert's "*.terragrunt-dev.managedkube.com"
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
* Using HTTP2, server supports multiplexing
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7f92ce011a00)
> GET /jquery-3.1.1.min.js HTTP/2
> Host: sample-app-2.terragrunt-dev.managedkube.com
> user-agent: curl/7.79.1
> accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 2147483647)!
< HTTP/2 404 
< date: Wed, 29 Jun 2022 19:38:21 GMT
< server: istio-envoy
< 
* Connection #0 to host sample-app-2.terragrunt-dev.managedkube.com left intact
```

Manually testing the change on the ingress to add a `*` in the path:
```
Rules:
  Host                                         Path  Backends
  ----                                         ----  --------
  sample-app-2.terragrunt-dev.managedkube.com  /*
                          
```

This fixes the problem.

Rolling that fix into code:

PR: https://github.com/ManagedKube/kubernetes-ops/pull/355

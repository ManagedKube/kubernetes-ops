# AWS Managed Prometheus (AMP)

AMP Docs: https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html

This module is geared towards creating a centralized Prometheus collector.

```
                                               ┌───────────────────────────────────────────────────────────────┐
                                               │                                                               │
                                               │                                                               │
                                               │                                                               │
                                               │                                                               │
┌──────────────────────────────┐               │         ┌──────────────────────────────────────────────┐      │
│                              │               │         │                                              │      │
│                              │               │         │                                              │      │
│                              │               │         │                                              │      │
│     ┌─────────────────┐      │               │         │        ┌─────────────────────────────┐       │      │
│     │       AWS       │      │               │         │        │                             │       │      │
│     │    Managed      │      │   (3) remote  │         │        │   kube-prometheus-stack     │       │      │
│     │    Prometheus   │◄─────┼───────────────┼─────────┼────────┤                             │       │      │
│     │                 │      │     write     │         │        │                             │       │      │
│     └─────────────────┘      │               │         │        │                             │       │      │
│                              │               │         │        │                             │       │      │
│      ┌──────────┐            │               │         │        │      ┌──────────┐           │       │      │
│      │    AWS   │            │   (1) trust   │         │        │      │ service  │           │       │      │
│      │ identity ├────────────┼───────────────┼────────►│        │      │ account  │           │       │      │
│      │ provider │            │   relationship│         │        │      └─────▲────┘           │       │      │
│      └──────────┘            │   to EKS      │         │        │            │                │       │      │
│                              │               │         │        │            │                │       │      │
│      ┌───────────┐           │               │         │        └────────────┼────────────────┘       │      │
│      │  IAM      │           │  (2) Service  │         │                     │                        │      │
│      │ role      ├───────────┼───────────────┼─────────┼─────────────────────┘                        │      │
│      │Federation │           │  account      │         │                                              │      │
│      └───────────┘           │  assume       │         │                                              │      │
│                              │  role         │         │                                              │      │
│                              │               │         │                 EKS Cluster                  │      │
│            VPC               │               │         │                                              │      │
│       AWS Account #1         │               │         └──────────────────────────────────────────────┘      │
└──────────────────────────────┘               │                                                               │
                                               │                                                               │
                                               │                                                               │
                                               │                              VPC                              │
                                               │                      AWS Account #2                           │
                                               └───────────────────────────────────────────────────────────────┘
```

The main use case for this is that when we deploy out kubernetes-ops we will be creating at least 2 or 3 environments.  One
for dev, qa, sandbox/uat/etc, and prod (maybe more depending on how many levels we want to go through).  The desire is to
not have to go to each environment's Prometheus to get metrics or to and/or to offload the metrics to another environment
for redundancy/backup/compliance reasons.  There could also be more than one setup for this, one for pre-production environments and one for production environments, depending on what the requirements are for separating the data.

# How
AWS has a blog that does essentially the exact thing we want but for an S3 bucket:

https://aws.amazon.com/blogs/containers/cross-account-iam-roles-for-kubernetes-service-accounts/

We are going to take this process and narrowly alter it for our needs.

This module is creating an AWS Identity Provider in the account where AMP is created in and it grants access
to one or more external EKS cluster that are not in the same AWS account (however, the EKS cluster can be
in the same AWS account).  The IAM role created uses this Identity Provider for authentication of the remote
EKS pod trying to assume this role and it is scoped down to the EKS Kubernetes service account and Kubernetes
namespace.

From the above picture:
(1) An AWS Identity Provider is created in the AWS account #1 that has the identity provider (IdP) of the AWS
account #2's EKS cluster (each EKS cluster creates an IdP).  This means that aws account #1 knows about the
AWS account #2's EKS cluster at this point.  It knows it's endpoint but we havent applied any rules to what
to trust about it yet.  We will now be able to reference this Identity Providers in the upcoming IAM roles
and when AWS is trying to validate an incoming authentication request it will go to this EKS cluster's IdP for
verification of the identity.

(2) There are two things happening here.

The first one is that in the AWS account #1 an IAM role is created with certain attributes:
* The Trust Relationship json points to the AWS Identity provider we created in the previous step.  This is
  saying that when something is trying to assume this IAM role, this is the how we will validate it.
* The Trust Relationship json validates the attributes in the authentication JWT sent to us.  These items
  are cryptographically signed by the source EKS cluster so it is very difficult to spoof this if you don't
  have control of the source EKS cluster.  We are limiting the access to that particular EKS cluster, that
  it is a kubernetes service accout, the kubernetes namespace that it comes from, and the name of the
  kubernetes service account.  This scopes it down tightly to a very limited set on what the source identity can be.
* The permission which is the IAM policy attached to this role grants permission for assuming roles and 
  permission to write to the AWS managed Prometheus.  It also scopes the resource to the ARN of this AMP
  that this module creates.

The second thing is on the AWS account #2 side, a service account is created and the EKS IRSA assume role
annotations are placed onto it.  The role ARN is the ARN from the AWS account #1 side.  The service account
will have all of the previous attributes we specified and the Prometheus using this service account identity
will assume the IAM role that was created in AWS account #1.  It will send the it's identity and the cryptographically
signed items of it's own identity (which we have meticulously crafted to match in the previous section) to AWS STS.
Then AWS STS will proceed to validate the identity to ensure that the identity sent in is who they say they are.
It will go to the AWS account #2's EKS cluster's IdP to validate per the AWS account #1's Identity provider's 
information.  This is important because at this point AWS account #1 can NOT trust anything that the AWS account
#2 assume role information that is given.  It could be just any random auth request from the internet.  With the
information that was previously configured into the AWS account #1's about this identity provider it uses this
information to go forth and verifying the information.  Once that information is verified successfully it will return to
the AWS account #2's prometheus a set of temporary AWS credential it can use to gain access to the AWS account #1's
AMP per the IAM policy attached to this role.

TODO:
* A ladder diagram of this flow might be easier to express and understand?

# Troubleshooting
Getting this to work correctly can sometimes be challenging.  A few things has to align specifically or the
assuming the role will not work and sometimes it is hard to get information on which part is not working.  The
following tries to help you in getting a setup where you can test out trying to assume the role from a remote
EKS cluster's pod so that you can test out what exact strings you have to pass into the module to make this work
correctly.

The AWS blog above in the section `Verify the procedure works` has a good walk through (and where this was taken
from) on how to test it out.

Start an ubuntu pod in the namespace where you are adding permissions for Prometheus in.

Attach the Kubernetes service account to this ubuntu pod

Exec into the ubuntu pod and install the AWS CLI

Run:
```
aws sts assume-role-with-web-identity --role-arn $AWS_ROLE_ARN --role-session-name x-account --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE --duration 1500
```

The `AWS_*` vars are autopopulated into your pod when you add in the service account and if you are in AWS.

If the command is successful, you should get a return response such as: 
```
{
    "Credentials": {
        "AccessKeyId": "ASIATKVYE24LRQWGORWC",
        "SecretAccessKey": "bMkN8TCD7thnQPbJzOpbRUIbCJMuUV.....",
        "SessionToken": "IQoJb3JpZ2luX2VjEF8aCXVzLXdlc3QtMiJHMEUCIQDYGv0dkM4Rk9gePcs0wdSJcdLSmg9F+mG5Qt8iWtfGygIgBInTt0sYANyCWThIMgYy07wxkkSVHSc5hk0Xf9kyYZ4q+gQIyP//////////ARABGgwyMjkwOTMyMDE2ODciDAAHYiOCftTyXRSU7irOBOIeuZMMsIcpPd36icCkeDAYC2qw3HMxNmbT/21slnIEjLzuk5FYBV/SEDXck5ZwcAYxXKFY2iag2Rrr/bcsAblOsP2HH.........",
        "Expiration": "2022-08-15T23:31:53+00:00"
    },
    "SubjectFromWebIdentityToken": "system:serviceaccount:default:s3-shared-content",
    "AssumedRoleUser": {
        "AssumedRoleId": "AROATKVYE24L2HFUPPRWQ:x-account",
        "Arn": "arn:aws:sts::1111111111111:assumed-role/aws-managed-prometheus-ops/x-account"
    },
    "Provider": "arn:aws:iam::1111111111111:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B4EA44BE30ABD91AC23C475F32379593",
    "Audience": "sts.amazonaws.com"
}
```

If not, you will receive an error.

Thing to try:
* Look at the AWS Role that was created and look at the Trust Relationship
* The Statement.Principal.Federated value should be the arn of the Identity Provider that was created in this module
* The Statement.Condition.StringEqual
  * `oidc.eks.us-west-2.amazonaws.com/id/<Remote EKS ID>:sub` - the `<Remote EKS ID>` should be the ID of the remote EKS cluster
  * should be in this format.  `system:serviceaccount:<k8s namespace>:<k8s service account name>`.  It will not work if it is not.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 3.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.iam_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account\_id of your AWS Account. This allows sure the use of the account number in the role to mitigate issue of aws\_caller\_id showing *** by obtaining the value of account\_id | `string` | `null` | no |
| <a name="input_iam_access_grant_list"></a> [iam\_access\_grant\_list](#input\_iam\_access\_grant\_list) | The list of IAM roles for granting various EKS cluster(s) permissions to perform a remote write to this AMP instance. | `list` | <pre>[<br>  {<br>    "description": "To grant access to the remote EKS cluster",<br>    "eks_cluster_oidc_issuer_url": "https://xxxxxxxxxxxxxxxxxxxxx.sk1.us-east-1.eks.amazonaws.com",<br>    "environment_name": "dev",<br>    "instance_name": "dev cluster",<br>    "kube_service_account_name": "kube-prometheus-stack-prometheus",<br>    "namespace": "monitoring",<br>    "oidc_provider_client_id_list": [<br>      "sts.amazonaws.com"<br>    ],<br>    "oidc_provider_thumbprint_list": [<br>      "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"<br>    ],<br>    "oidc_provider_url": "https://oidc.eks.us-east-1.amazonaws.com/id/B4EA44BE30ABD91AC23C475F3237111"<br>  }<br>]</pre> | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | An instance name to attach to some resources.  Optional only needed if you are going to create more than one of these items in an AWS account | `string` | `"env"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS tags | `map(any)` | n/a | yes |
| <a name="input_workspace_alias"></a> [workspace\_alias](#input\_workspace\_alias) | n/a | `string` | `"prometheus-test"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN |
| <a name="output_id"></a> [id](#output\_id) | Identifier of the workspace |
| <a name="output_prometheus_endpoint"></a> [prometheus\_endpoint](#output\_prometheus\_endpoint) | Prometheus endpoint available for this workspace. |

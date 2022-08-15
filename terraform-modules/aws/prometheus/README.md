# AWS Managed Prometheus (AMP)

AMP Docs: https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html

This module is geared towards creating a centralized Prometheus collector.

```
                                               ┌───────────────────────────────────────────────────────────────┐
                                               │                      AWS account 2                            │
                                               │                                                               │
                                               │                                                               │
                                               │                                                               │
┌──────────────────────────────┐               │         ┌──────────────────────────────────────────────┐      │
│       AWS account 1          │               │         │                                              │      │
│                              │               │         │                                              │      │
│                              │               │         │                                              │      │
│     ┌─────────────────┐      │               │         │        ┌─────────────────────────────┐       │      │
│     │      AWS        │      │               │         │        │                             │       │      │
│     │    Managed      │      │     Remote    │         │        │   kube-prometheus-stack     │       │      │
│     │    Prometheus   │◄─────┼───────────────┼─────────┼────────┤                             │       │      │
│     │                 │      │     Write     │         │        │                             │       │      │
│     └─────────────────┘      │               │         │        │                             │       │      │
│                              │               │         │        └─────────────────────────────┘       │      │
│                              │               │         │                                              │      │
│           VPC                │               │         │                                              │      │
└──────────────────────────────┘               │         │                                              │      │
                                               │         │                  EKS Cluster                 │      │
                                               │         └──────────────────────────────────────────────┘      │
                                               │                                                               │
                                               │                                                               │
                                               │                             VPC                               │
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

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

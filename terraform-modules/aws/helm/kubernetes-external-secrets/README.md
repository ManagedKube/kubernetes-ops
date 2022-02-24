#  kubernetes-external-secrets

# Deprecated
This helm chart has been deprecated in favor of the `external-secrets` helm chart

Source project: https://github.com/external-secrets/kubernetes-external-secrets
Source chart: https://github.com/external-secrets/kubernetes-external-secrets/tree/master/charts/kubernetes-external-secrets

EKS Kubernetes v1.19+

## Useful guides
Getting the IAM policies and trust relationships to all align up is tricky.  If something is not set correctly like
the name is off in one of the place, the entire sequence of chained identity fails and it is hard to figure out where
exactly.  You can guess and see if it is something obvious but if it is not, then you should just follow each of the
resources through to make sure everything is setup correctly.

Here is the doc on how to setup IAM for ServiceAccounts: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

At the bottom of this doc it will link to how to create each of the items.  Following each one through to make sure these
items exist and the names all match up is critical for this entire setup.

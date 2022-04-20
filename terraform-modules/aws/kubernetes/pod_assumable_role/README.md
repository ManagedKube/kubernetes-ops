# pod_assumable_role

This module helps you to create an AWS IAM assumable role by a pod.

https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

This will allow you to give a pod in an EKS cluster a role to assume to gain access to AWS resources instead
of having to pass an AWS key pair to the pod.  This is the preferred method since AWS key
pairs are long lived static keys while the assumable roles generates short lived keys that
are constantly rotated.

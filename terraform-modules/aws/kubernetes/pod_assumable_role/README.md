# pod_assumable_role

This module helps you to create an AWS IAM assumable role by a pod.

https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

This will allow you to give a pod in an EKS cluster a role to assume to gain access to AWS resources instead
of having to pass an AWS key pair to the pod.  This is the preferred method since AWS key
pairs are long lived static keys while the assumable roles generates short lived keys that
are constantly rotated.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role"></a> [iam\_assumable\_role](#module\_iam\_assumable\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.20.3 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#input\_eks\_cluster\_oidc\_issuer\_url) | EKS cluster oidc issuer url | `string` | `""` | no |
| <a name="input_iam_policy_description"></a> [iam\_policy\_description](#input\_iam\_policy\_description) | The description to place onto the IAM policy | `string` | `"The policy created by the pod_assumable_role Terraform module"` | no |
| <a name="input_iam_policy_json"></a> [iam\_policy\_json](#input\_iam\_policy\_json) | The IAM policy json | `string` | `"{}"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | The namespace that this service account will be used in | `string` | `"my_namespace"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to use for the various resources: IAM role, policy, etc | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Set of tags to place on the resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |

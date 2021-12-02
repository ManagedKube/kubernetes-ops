## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.certificate](https://registry.terraform.io/providers/hashicorp/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.gateway](https://registry.terraform.io/providers/hashicorp/kubectl/latest/docs/resources/manifest) | resource |
| [aws_eks_cluster_auth.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [template_file.certificate](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.gateway](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | The common name for the certificate | `string` | n/a | yes |
| <a name="input_cert_dns_name"></a> [cert\_dns\_name](#input\_cert\_dns\_name) | The dns name for the certificate | `string` | n/a | yes |
| <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate) | The eks kubernetes cluster\_ca\_certificate | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_issue_ref_group"></a> [issue\_ref\_group](#input\_issue\_ref\_group) | n/a | `string` | `"cert-manager.io"` | no |
| <a name="input_issue_ref_kind"></a> [issue\_ref\_kind](#input\_issue\_ref\_kind) | n/a | `string` | `"ClusterIssuer"` | no |
| <a name="input_issue_ref_name"></a> [issue\_ref\_name](#input\_issue\_ref\_name) | n/a | `string` | `"letsencrypt-prod-dns01"` | no |
| <a name="input_kubernetes_api_host"></a> [kubernetes\_api\_host](#input\_kubernetes\_api\_host) | The eks kubernetes api host endpoint | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The kubernetes namespace to deploy into | `string` | `"istio-system"` | no |

## Outputs

No outputs.

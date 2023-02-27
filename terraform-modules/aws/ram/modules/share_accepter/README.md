# terraform-aws-tardigrade-ram-principal-association/share_accepter

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_share_arn"></a> [resource\_share\_arn](#input\_resource\_share\_arn) | ARN of the resource share | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_share_accepter"></a> [share\_accepter](#output\_share\_accepter) | Object with the AWS RAM share accepter resource |

<!-- END TFDOCS -->

# terraform-aws-tardigrade-ram-principal-association/resource_association

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
| <a name="input_resource_arn"></a> [resource\_arn](#input\_resource\_arn) | ARN of the resource to associate with the RAM Resource Share | `string` | n/a | yes |
| <a name="input_resource_share_arn"></a> [resource\_share\_arn](#input\_resource\_share\_arn) | ARN of the resource share | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_association"></a> [resource\_association](#output\_resource\_association) | Object with the AWS RAM resource association resource |

<!-- END TFDOCS -->

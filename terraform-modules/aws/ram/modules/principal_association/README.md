# terraform-aws-tardigrade-ram-principal-association/principal_association

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
| <a name="input_principal"></a> [principal](#input\_principal) | The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN. | `string` | n/a | yes |
| <a name="input_resource_share_arn"></a> [resource\_share\_arn](#input\_resource\_share\_arn) | ARN of the resource share | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_principal_association"></a> [principal\_association](#output\_principal\_association) | Object with the AWS RAM principal association resource |

<!-- END TFDOCS -->

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_workspaces_ip_group.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/workspaces_ip_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the AWS account | `string` | n/a | yes |
| <a name="input_ip_group_rules"></a> [ip\_group\_rules](#input\_ip\_group\_rules) | A list of IP group rules with source and description.<br>    Example:<br>    [<br>    {<br>        source      = "150.24.14.0/24"<br>        description = "NY"<br>    },<br>    {<br>        source      = "125.191.14.85/32"<br>        description = "LA"<br>    },<br>    {<br>        source      = "44.98.100.0/24"<br>        description = "STL"<br>    }<br>    ] | <pre>list(object({<br>    source      = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of key-value pairs to assign as tags to the AWS resources created by this Terraform configuration. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspaces_ip_group_id"></a> [workspaces\_ip\_group\_id](#output\_workspaces\_ip\_group\_id) | The IP group identifier. |

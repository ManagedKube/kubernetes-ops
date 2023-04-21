## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance_association.extra_sg_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance_association) | resource |
| [aws_instance_association.extra_sg_association-fetch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance_association) | resource |
| [aws_instances.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [null_data_source.example](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fetch_ec2_instance_name"></a> [fetch\_ec2\_instance\_name](#input\_fetch\_ec2\_instance\_name) | The name of the EC2 instances to fetch | `string` | `""` | no |
| <a name="input_fetch_ec2_instance_sg_id"></a> [fetch\_ec2\_instance\_sg\_id](#input\_fetch\_ec2\_instance\_sg\_id) | The id of the SG to associate to EC2 instances to fetch | `string` | `""` | no |
| <a name="input_fetch_ec2_instances"></a> [fetch\_ec2\_instances](#input\_fetch\_ec2\_instances) | A boolean to decide whether to fetch EC2 instances | `bool` | `false` | no |
| <a name="input_instance_security_group_pairs"></a> [instance\_security\_group\_pairs](#input\_instance\_security\_group\_pairs) | List of objects containing EC2 instance IDs and Security Group IDs to associate.<br>  if you set fetch\_ec2\_instances = true, This variable will not be functional. <br>  Each object should have the following structure:<br>  {<br>    instance\_id      = "i-0123456789abcdef0"<br>    security\_group\_id = "sg-0123456789abcdef0"<br>  }<br>  Example:<br>  [<br>    {<br>      instance\_id      = "i-0123456789abcdef0"<br>      security\_group\_id = "sg-0123456789abcdef0"<br>    },<br>    {<br>      instance\_id      = "i-0123456789abcdef1"<br>      security\_group\_id = "sg-0123456789abcdef1"<br>    }<br>  ] | <pre>list(object({<br>    instance_id      = string<br>    security_group_id = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | n/a |

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
| [aws_instance_association.extra_sg_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_security_group_pairs"></a> [instance\_security\_group\_pairs](#input\_instance\_security\_group\_pairs) | List of objects containing EC2 instance IDs and Security Group IDs to associate.<br>  Each object should have the following structure:<br>  {<br>    instance\_id      = "i-0123456789abcdef0"<br>    security\_group\_id = "sg-0123456789abcdef0"<br>  }<br>  Example:<br>  [<br>    {<br>      instance\_id      = "i-0123456789abcdef0"<br>      security\_group\_id = "sg-0123456789abcdef0"<br>    },<br>    {<br>      instance\_id      = "i-0123456789abcdef1"<br>      security\_group\_id = "sg-0123456789abcdef1"<br>    }<br>  ] | <pre>list(object({<br>    instance_id      = string<br>    security_group_id = string<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.

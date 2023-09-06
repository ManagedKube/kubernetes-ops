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
| [aws_lb.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.tg-attachment-1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.tg-attachment-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.tg-attachment-3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Set to true to enable cross-zone load balancing for the NLB. | `bool` | `false` | no |
| <a name="input_enable_custom_nlb_access_logs_s3_prefix"></a> [enable\_custom\_nlb\_access\_logs\_s3\_prefix](#input\_enable\_custom\_nlb\_access\_logs\_s3\_prefix) | Set to true to use custom\_nlb\_access\_logs\_s3\_prefix for access logs. Set to false to use nlb\_name as the prefix. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Set to true to enable deletion protection for the NLB. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Set to true to enable HTTP/2 for the NLB. | `bool` | `false` | no |
| <a name="input_enable_internal"></a> [enable\_internal](#input\_enable\_internal) | Set to true to create an internal load balancer, otherwise set to false for a public load balancer. | `bool` | `true` | no |
| <a name="input_enable_nlb_access_logs"></a> [enable\_nlb\_access\_logs](#input\_enable\_nlb\_access\_logs) | Set to a list containing bucket\_name and bucket\_prefix to enable NLB access logs. Leave empty to disable NLB access logs to S3. | `list(any)` | `[]` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | The port on which the listener listens. | `string` | `"80"` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | The protocol used by the listener. | `string` | `"HTTP"` | no |
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | The name of the Network Load Balancer (NLB). It should be 32 characters or less. | `string` | n/a | yes |
| <a name="input_nlb_security_groups"></a> [nlb\_security\_groups](#input\_nlb\_security\_groups) | Security Group to filter traffict to load balancer | `string` | n/a | yes |
| <a name="input_nlb_subnets"></a> [nlb\_subnets](#input\_nlb\_subnets) | List of subnets where the NLB will be deployed. | `list(string)` | n/a | yes |
| <a name="input_nlb_tags"></a> [nlb\_tags](#input\_nlb\_tags) | A map of tags to apply to the NLB resource. | `map(any)` | <pre>{<br>  "appname": "nlb"<br>}</pre> | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | The name of the Target Group. | `any` | n/a | yes |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | The port on which the Target Group listens. | `number` | `80` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | The protocol used by the Target Group. | `string` | `"HTTP"` | no |
| <a name="input_target_vpc_id"></a> [target\_vpc\_id](#input\_target\_vpc\_id) | The VPC where the targets' endpoints are deployed. | `string` | n/a | yes |
| <a name="input_tg_attachment_ip_1"></a> [tg\_attachment\_ip\_1](#input\_tg\_attachment\_ip\_1) | The IP address of the first target to attach to the Target Group. | `string` | n/a | yes |
| <a name="input_tg_attachment_ip_2"></a> [tg\_attachment\_ip\_2](#input\_tg\_attachment\_ip\_2) | The IP address of the second target to attach to the Target Group. | `string` | n/a | yes |
| <a name="input_tg_attachment_ip_3"></a> [tg\_attachment\_ip\_3](#input\_tg\_attachment\_ip\_3) | The IP address of the third target to attach to the Target Group. | `string` | n/a | yes |
| <a name="input_tg_attachment_port_1"></a> [tg\_attachment\_port\_1](#input\_tg\_attachment\_port\_1) | The port number on which the first target listens, used for attaching to the Target Group. | `number` | n/a | yes |
| <a name="input_tg_attachment_port_2"></a> [tg\_attachment\_port\_2](#input\_tg\_attachment\_port\_2) | The port number on which the second target listens, used for attaching to the Target Group. | `number` | n/a | yes |
| <a name="input_tg_attachment_port_3"></a> [tg\_attachment\_port\_3](#input\_tg\_attachment\_port\_3) | The port number on which the third target listens, used for attaching to the Target Group. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_external_dns"></a> [load\_balancer\_external\_dns](#output\_load\_balancer\_external\_dns) | DNS name for the Network Load Balancer |

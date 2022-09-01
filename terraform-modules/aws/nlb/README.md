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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_s3_bucket_name"></a> [access\_logs\_s3\_bucket\_name](#input\_access\_logs\_s3\_bucket\_name) | The name to use for the S3 bucket where the NLB access logs will be stored. If you set this to null, a name will be generated automatically based on var.nlb\_name. | `string` | `null` | no |
| <a name="input_custom_nlb_access_logs_s3_prefix"></a> [custom\_nlb\_access\_logs\_s3\_prefix](#input\_custom\_nlb\_access\_logs\_s3\_prefix) | Prefix to use for access logs to create a sub-folder in S3 Bucket name where NLB logs should be stored. Only used if var.enable\_custom\_nlb\_access\_logs\_s3\_prefix is true. | `string` | `null` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Set enable\_cross\_zone\_load\_balancing | `bool` | `false` | no |
| <a name="input_enable_custom_nlb_access_logs_s3_prefix"></a> [enable\_custom\_nlb\_access\_logs\_s3\_prefix](#input\_enable\_custom\_nlb\_access\_logs\_s3\_prefix) | Set to true to use the value of nlb\_access\_logs\_s3\_prefix for access logs prefix. If false, the nlb\_name will be used. This is useful if you wish to disable the S3 prefix. Only used if var.enable\_nlb\_access\_logs is true. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable deletion protection | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | enable\_http2 | `bool` | `false` | no |
| <a name="input_enable_internal"></a> [enable\_internal](#input\_enable\_internal) | Enable internal load balancer | `bool` | `true` | no |
| <a name="input_enable_nlb_access_logs"></a> [enable\_nlb\_access\_logs](#input\_enable\_nlb\_access\_logs) | This is Optional, Only used to output the NLB logs to S3. we need to input bucket\_name and bucket\_prefix to the list. if left empty it will not output the logs to S3 | `list(any)` | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates whether the access logs bucket should be destroyed, even if there are files in it, when you run Terraform destroy. Unless you are using this bucket only for test purposes, you'll want to leave this variable set to false. | `bool` | `false` | no |
| <a name="input_nlb_access_logs_s3_bucket_name"></a> [nlb\_access\_logs\_s3\_bucket\_name](#input\_nlb\_access\_logs\_s3\_bucket\_name) | The S3 Bucket name where NLB logs should be stored. If left empty, no NLB logs will be captured. Tip: It's easiest to create the S3 Bucket using the Gruntwork Module https://github.com/gruntwork-io/terraform-aws-monitoring/tree/master/modules/logs/load-balancer-access-logs. | `string` | `null` | no |
| <a name="input_nlb_access_logs_s3_prefix"></a> [nlb\_access\_logs\_s3\_prefix](#input\_nlb\_access\_logs\_s3\_prefix) | nlb\_access\_logs\_s3\_prefix | `string` | `null` | no |
| <a name="input_nlb_name"></a> [nlb\_name](#input\_nlb\_name) | The name of the NLB. Do not include the environment name since this module will automatically append it to the value of this variable. | `string` | n/a | yes |
| <a name="input_nlb_s3_bucket_name"></a> [nlb\_s3\_bucket\_name](#input\_nlb\_s3\_bucket\_name) | nlb\_s3\_bucket\_name | `string` | `null` | no |
| <a name="input_nlb_subnets"></a> [nlb\_subnets](#input\_nlb\_subnets) | NLB Subnets | `list(string)` | n/a | yes |
| <a name="input_nlb_tags"></a> [nlb\_tags](#input\_nlb\_tags) | Tags | `map(any)` | <pre>{<br>  "appname": "nlb"<br>}</pre> | no |
| <a name="input_num_days_after_which_archive_log_data"></a> [num\_days\_after\_which\_archive\_log\_data](#input\_num\_days\_after\_which\_archive\_log\_data) | After this number of days, log files should be transitioned from S3 to Glacier. Enter 0 to never archive log data. | `number` | n/a | yes |
| <a name="input_num_days_after_which_delete_log_data"></a> [num\_days\_after\_which\_delete\_log\_data](#input\_num\_days\_after\_which\_delete\_log\_data) | After this number of days, log files should be deleted from S3. Enter 0 to never delete log data. | `number` | n/a | yes |
| <a name="input_should_create_access_logs_bucket"></a> [should\_create\_access\_logs\_bucket](#input\_should\_create\_access\_logs\_bucket) | If true, create a new S3 bucket for access logs with the name in var.access\_logs\_s3\_bucket\_name. If false, assume the S3 bucket for access logs with the name in  var.access\_logs\_s3\_bucket\_name already exists, and don't create a new one. Note that if you set this to false, it's up to you to ensure that the S3 bucket has a bucket policy that grants Elastic Load Balancing permission to write the access logs to your bucket. | `bool` | `true` | no |

## Outputs

No outputs.

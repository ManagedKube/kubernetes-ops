## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.11.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.extra-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_mwaa_environment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mwaa_environment) | resource |
| [aws_s3_bucket.airflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_configuration_options"></a> [airflow\_configuration\_options](#input\_airflow\_configuration\_options) | (Optional) The airflow\_configuration\_options parameter specifies airflow override options. Check the Official documentation for all possible configuration options. | `map(string)` | `null` | no |
| <a name="input_airflow_name"></a> [airflow\_name](#input\_airflow\_name) | Airflow name | `string` | `"airflow"` | no |
| <a name="input_airflow_version"></a> [airflow\_version](#input\_airflow\_version) | (Optional) Airflow version of your environment, will be set by default to the latest version that MWAA supports. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region | `string` | `"us-east-1"` | no |
| <a name="input_dag_processing_log_level"></a> [dag\_processing\_log\_level](#input\_dag\_processing\_log\_level) | The log level: INFO \| WARNING \| ERROR \| CRITICAL | `string` | `"INFO"` | no |
| <a name="input_dag_s3_path"></a> [dag\_s3\_path](#input\_dag\_s3\_path) | The dag's S3 path | `string` | `"dags/"` | no |
| <a name="input_environment_class"></a> [environment\_class](#input\_environment\_class) | (Optional) Environment class for the cluster. Possible options are mw1.small, mw1.medium, mw1.large. Will be set by default to mw1.small. Please check the AWS Pricing for more information about the environment classes. | `string` | `"mw1.small"` | no |
| <a name="input_iam_extra_policies"></a> [iam\_extra\_policies](#input\_iam\_extra\_policies) | List of additional policies to create and attach to the IAM role | <pre>list(object({<br>    name_prefix = string<br>    policy_json = string<br>  }))</pre> | `[]` | no |
| <a name="input_max_workers"></a> [max\_workers](#input\_max\_workers) | (Optional) The maximum number of workers that can be automatically scaled up. Value need to be between 1 and 25. Will be 10 by default. | `number` | `10` | no |
| <a name="input_min_workers"></a> [min\_workers](#input\_min\_workers) | (Optional) The minimum number of workers that you want to run in your environment. Will be 1 by default. | `number` | `1` | no |
| <a name="input_requirements_s3_path"></a> [requirements\_s3\_path](#input\_requirements\_s3\_path) | The S3 path for the MWAA requirements file. | `string` | `""` | no |
| <a name="input_scheduler_log_level"></a> [scheduler\_log\_level](#input\_scheduler\_log\_level) | The log level: INFO \| WARNING \| ERROR \| CRITICAL | `string` | `"INFO"` | no |
| <a name="input_sg_extra_ids"></a> [sg\_extra\_ids](#input\_sg\_extra\_ids) | List of additional sg to create and attach to Airflow | `list(string)` | `[]` | no |
| <a name="input_source_bucket_arn"></a> [source\_bucket\_arn](#input\_source\_bucket\_arn) | The Dag's S3 bucket arn: arn:aws:s3:::bucketname | `string` | `"s3://foo"` | no |
| <a name="input_source_bucket_name"></a> [source\_bucket\_name](#input\_source\_bucket\_name) | The Dag's S3 bucket name | `string` | `"foo"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | (Required) The private subnet IDs in which the environment should be created. MWAA requires two subnets. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A set of tags to place on the items | `any` | `{}` | no |
| <a name="input_task_log_level"></a> [task\_log\_level](#input\_task\_log\_level) | The log level: INFO \| WARNING \| ERROR \| CRITICAL | `string` | `"INFO"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc ID | `string` | `""` | no |
| <a name="input_webserver_access_mode"></a> [webserver\_access\_mode](#input\_webserver\_access\_mode) | (Optional) Specifies whether the webserver should be accessible over the internet or via your specified VPC. Possible options: PRIVATE\_ONLY (default) and PUBLIC\_ONLY | `string` | `"PRIVATE_ONLY"` | no |
| <a name="input_webserver_log_level"></a> [webserver\_log\_level](#input\_webserver\_log\_level) | The log level: INFO \| WARNING \| ERROR \| CRITICAL | `string` | `"INFO"` | no |
| <a name="input_worker_log_level"></a> [worker\_log\_level](#input\_worker\_log\_level) | The log level: INFO \| WARNING \| ERROR \| CRITICAL | `string` | `"INFO"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_webserver_url"></a> [webserver\_url](#output\_webserver\_url) | n/a |

## Rough edges
In default section we have a statement policy as the following
```
{
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:GenerateDataKey*",
                "kms:Encrypt"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": [
                        "sqs.${aws_region}.amazonaws.com",
                        "s3.${aws_region}.amazonaws.com"
                    ]
                }
            }
        }
```
We didn't want to leave this as 
```
"Resource": "*",
``` 
We were working hard to find out why this only works with asterisk, and in the end chat gtp helped me with the answer since there is little documentation.
finally Chat GPT was able to help 

### chat gpt said:
if you are using the default aws/airflow (which is our case in airflow with default policy) KMS key, you do not need to include a specific policy for KMS in your 
IAM role. The necessary permissions to use this key are already granted by the service to your Amazon MWAA environment.
Since you are using the default aws/airflow KMS key, you cannot specify its ARN directly in the policy. You can set the "Resource" field to "*" to allow access to all 
KMS keys in your account

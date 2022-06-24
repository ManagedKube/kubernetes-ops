## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cis_alarms"></a> [cis\_alarms](#module\_cis\_alarms) | cloudposse/cloudtrail-cloudwatch-alarms/aws | 0.14.3 |
| <a name="module_cloudtrail"></a> [cloudtrail](#module\_cloudtrail) | cloudposse/cloudtrail/aws | 0.17.0 |
| <a name="module_cloudtrail_s3_bucket"></a> [cloudtrail\_s3\_bucket](#module\_cloudtrail\_s3\_bucket) | github.com/ManagedKube/terraform-aws-cloudtrail-s3-bucket.git// | 0.24.0 |
| <a name="module_metric_configs"></a> [metric\_configs](#module\_metric\_configs) | cloudposse/config/yaml | 0.7.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cloudtrail_cloudwatch_events_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_bucket_name"></a> [access\_log\_bucket\_name](#input\_access\_log\_bucket\_name) | Name of the S3 bucket where s3 access log will be sent to | `string` | `""` | no |
| <a name="input_acl"></a> [acl](#input\_acl) | The canned ACL to apply. We recommend log-delivery-write for compatibility with AWS services | `string` | `"log-delivery-write"` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_allow_ssl_requests_only"></a> [allow\_ssl\_requests\_only](#input\_allow\_ssl\_requests\_only) | Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_cloudtrail_event_selector"></a> [cloudtrail\_event\_selector](#input\_cloudtrail\_event\_selector) | This enables the cloudtrail even selector to track all S3 API calls by default: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail. | `list(object({include_management_events = bool, read_write_type = string, data_resource = list(object({type = string, values = list(string)}))}))` | <pre>[<br>  {<br>    "data_resource": [<br>      {<br>        "type": "AWS::S3::Object",<br>        "values": [<br>          "arn:aws:s3"<br>        ]<br>      }<br>    ],<br>    "include_management_events": true,<br>    "read_write_type": "All"<br>  }<br>]</pre> | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `false` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Specifies whether the trail is created in the current region or in all regions | `bool` | `true` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_metrics_paths"></a> [metrics\_paths](#input\_metrics\_paths) | List of paths to CloudWatch metrics configurations | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Set to `false` to disable the restricting of making the bucket public | `bool` | `true` | no |
| <a name="input_s3_object_ownership"></a> [s3\_object\_ownership](#input\_s3\_object\_ownership) | Specifies the S3 object ownership control. Valid values are `ObjectWriter`, `BucketOwnerPreferred`, and 'BucketOwnerEnforced'. | `string` | `"BucketOwnerPreferred"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dashboard_combined"></a> [dashboard\_combined](#output\_dashboard\_combined) | n/a |
| <a name="output_dashboard_individual"></a> [dashboard\_individual](#output\_dashboard\_individual) | n/a |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |

## What does it solve?

https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#cis-1.1-remediation
https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#cis-3.3-remediation
- 1.1 – Avoid the use of the "root" account
- 3.3 – Ensure a log metric filter and alarm exist for usage of "root" account
https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html#securityhub-cis-controls-3.8
- 3.1 – Ensure a log metric filter and alarm exist for unauthorized API calls
- 3.2 – Ensure a log metric filter and alarm exist for AWS Management Console sign-in without MFA
- 3.4 – Ensure a log metric filter and alarm exist for IAM policy changes
- 3.5 – Ensure a log metric filter and alarm exist for CloudTrail configuration changes
- 3.6 – Ensure a log metric filter and alarm exist for AWS Management Console authentication failures
- 3.7 – Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer created CMKs
- 3.8 – Ensure a log metric filter and alarm exist for S3 bucket policy changes
- 3.9 – Ensure a log metric filter and alarm exist for AWS Config configuration changes
- 3.10 – Ensure a log metric filter and alarm exist for security group changes
- 3.11 – Ensure a log metric filter and alarm exist for changes to Network Access Control Lists (NACL)
- 3.12 – Ensure a log metric filter and alarm exist for changes to network gateways
- 3.13 – Ensure a log metric filter and alarm exist for route table changes
- 3.14 – Ensure a log metric filter and alarm exist for VPC changes

## Best practice for adding alarms ?
We recommend adding this file through the input variable: ```input_metrics_paths```
```
metrics_paths = ["./cis_benchmark.yaml"]
```
https://github.com/cloudposse/terraform-aws-cloudtrail-cloudwatch-alarms/blob/master/catalog/cis_benchmark.yaml 

If you want to add more alerts or modify existing alerts, you can use the following format:

```
ec2-instance-event-count:
  metric_name: "EC2InstanceEventCount"
  filter_pattern:
    "{ ($.eventName = RunInstances) || ($.eventName = RebootInstances) || ($.eventName = StartInstances) || ($.eventName
    = StopInstances) || ($.eventName = TerminateInstances) }"
  metric_namespace: "CISBenchmark"
  alarm_description: "Alarms when an API call is made to create, terminate, start, stop or reboot an EC2 instance."
  metric_value: "1"
  alarm_name: "EC2InstanceEventCountExceeded"
  alarm_comparison_operator: "GreaterThanOrEqualToThreshold"
  alarm_evaluation_periods: "1"
  alarm_period: "300"
  alarm_statistic: "Sum"
  alarm_treat_missing_data: "notBreaching"
  alarm_threshold: "1"
```
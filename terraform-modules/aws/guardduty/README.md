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
| [aws_guardduty_detector.guardduty_detector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_guardduty_enabled"></a> [guardduty\_enabled](#input\_guardduty\_enabled) | Enable monitoring and feedback reporting. Setting to false is equivalent to suspending GuardDuty. Defaults to true. | `bool` | `true` | no |
| <a name="input_guardduty_malware_protection_logs_enabled"></a> [guardduty\_malware\_protection\_logs\_enabled](#input\_guardduty\_malware\_protection\_logs\_enabled) | Configures Malware Protection. See Malware Protection, Scan EC2 instance with findings and EBS volumes. | `bool` | `false` | no |
| <a name="input_guardduty_s3_logs_enabled"></a> [guardduty\_s3\_logs\_enabled](#input\_guardduty\_s3\_logs\_enabled) | Configures S3 protection. See S3 Logs below for more details. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags for Guard Duty | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS account ID of the GuardDuty detector |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the GuardDuty detector |
| <a name="output_id"></a> [id](#output\_id) | The ID of the GuardDuty detector |

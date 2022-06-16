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
| [aws_sns_topic_subscription.user_updates_sqs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | (Required) In email endpoint is an email address. | `any` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Required) Protocol to use. Valid values are: sqs, sms, lambda, firehose, and application. Protocols email, email-json, http and https | `any` | n/a | yes |
| <a name="input_topic_arn"></a> [topic\_arn](#input\_topic\_arn) | (Required) ARN of the SNS topic to subscribe to. | `any` | n/a | yes |

## Outputs

No outputs.

## EC2 Tagging
- It collects information about running instances in the AWS (Amazon Web Services) cloud.
- It retrieves the identity of the AWS account that is executing the code.
- It creates a local variable called "instance_tags" that contains information about the instances and their associated tags.
- It applies the AWS EC2 tag to each instance based on the collected information.

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
| [aws_ec2_tag.tag_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_instances.existing_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_tags"></a> [account\_tags](#input\_account\_tags) | Tags for each AWS account.<br><br>This variable allows you to provide tags for different AWS accounts using a map structure. Each AWS account is identified by its unique account ID, and you can specify multiple tags for each account using key-value pairs.<br><br>Example Usage:<br><br>inputs:<br>  {<br>    "account\_id\_1" = {<br>      "key1" = "value1"<br>      "key2" = "value2"<br>      "key3" = "value3"<br>      "key4" = "value4"<br>    }<br>    "account\_id\_1" = {<br>      "key1" = "value1"<br>      "key2" = "value2"<br>      "key3" = "value3"<br>      "key4" = "value4"<br>    }<br>    ... (Add more AWS account tags here) ...<br>  } | `map(map(string))` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_tags"></a> [instance\_tags](#output\_instance\_tags) | n/a |

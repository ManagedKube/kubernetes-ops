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
| [aws_s3_object.directory_structure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket | `any` | n/a | yes |
| <a name="input_folder_structure"></a> [folder\_structure](#input\_folder\_structure) | The folder structure to create in S3. <br>Example usage:<br>[<br>    "folder1",<br>    "folder2",<br>    "folder3",<br>    "folder4/subfolder1/subfolder2"<br>] | `list(string)` | n/a | yes |

## Outputs

No outputs.

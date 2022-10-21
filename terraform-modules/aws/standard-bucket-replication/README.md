# Standard AWS Bucket with Replication

Standard Bucket creates an S3 Bucket using the publicly available [aws bucket terraform implementation](github.com/terraform-aws-modules/terraform-aws-s3-bucket) that is able to setup S3 replication as an option to another bucket (same region or different region).  You can
use this module to create a single bucket or a single bucket that replicates to another.  If you think you will ever have requirements
to replicate your bucket, you should use this module instead of the `standard-bucket` module.  

NOTE: Due to a bug in the AWS Terraform provider 'false' actually creates the bucket with versioning enabled but suspended. 'true' properly enables versioning. https://github.com/hashicorp/terraform-provider-aws/issues/4494

The goals:
* Enable simple PRs for AWS bucket requests.  
* Enable simple setup of a replicated S3 bucket setup

Background:

Review [Self Service Terraform Modules Document](https://qadium.atlassian.net/wiki/spaces/EN/pages/1704329276/Self-Service+Terraform+Modules+WIP)

## Module Usage

This module creates an AWS S3 Bucket

| Parameter Name | Required | Default Value | Description |
| --- | --- | --- | --- |
| bucket_name | **Yes** |  | The name of the bucket. |
| env | **Yes** |  | environment name for the bucket. |
| region | **Yes** |  | gcp region for the bucket. |
| group | **Yes** |  | group owner |
| acl | **No** | private | The canned ACL to apply. Defaults to 'private'. |
| tags | **No** | {} | Override Bucket tags derived from env and group parameters. |
| policy | **No** | null | Optional bucket policy to provide. |
| attach_policy | **No** | false | attatch the bucket policy default is false. |
| versioning | **No** | false | enable bucket versioning. NOTE: Due to a bug in the AWS Terraform provider 'false' actually creates the bucket with versioning enabled but suspended. 'true' properly enables versioning. |
| sse_algorithm | **No** | AES256 | bucket's server side side encryption algorithm. |
| cors_rule | **No** | [] | list of maps representing Cross-Origin Resource rules. |
| lifecycle_rules | **No** | [] | list of bucket object lifecycle rules. |
| block_public_acls | **No** | false | block public ACLs for this bucket default is false |
| block_public_policy | **No** | false | block public bucket policies for this bucket default is false |
| ignore_public_acls | **No** | false | ignore public ACLs for this bucket default is false |
| restrict_public_buckets | **No** | false | restrict public policies for this bucket default is false |
| replica_provider_profile | **No** | | AWS profile to use for the replica bucket|
| enable_replication | **No** | false | Enable replication or not: 0 or 1 |
| replica_region | **No** | | Region to create s3 replica bucket in|
| replica_bucket_name | **No** | | Replica bucket name |


## Supported Outputs
The following outputs are supported as part of this module:

| Output Name | Description |
| --- | --- |
| bucket_id | name of created bucket if creating a none replicated bucket |
| bucket_arn | arn of created bucket if creating a none replicated bucket |
| bucket_id_source_replica | name of the source bucket if creating a replicated bucket |
| bucket_arn_source_replica | arn of the source bucket if creating a replicated bucket |
| bucket_id_replica | name of the replicated bucket if creating a replicated bucket |
| bucket_arn_replica | arn of the replicated bucket if creating a replicated bucket |

## iam_members syntax:


## Examples

### Terraform

* See [tested default example](examples/default/)

### Terragrunt

* See [terragrunt.hcl](examples/terragrunt/terragrunt.hcl)

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
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Whether to create the IAM instance profile | `bool` | `false` | no |
| <a name="input_iam_assume_role_policy"></a> [iam\_assume\_role\_policy](#input\_iam\_assume\_role\_policy) | Json to create assume\_role\_policy in line | `string` | `"{}"` | no |
| <a name="input_iam_description"></a> [iam\_description](#input\_iam\_description) | (Optional) Description of the role. | `string` | `"New Role created from ManagedKube Module"` | no |
| <a name="input_iam_force_detach_policies"></a> [iam\_force\_detach\_policies](#input\_iam\_force\_detach\_policies) | (Optional) Whether to force detaching any policies the role has before destroying it | `bool` | `false` | no |
| <a name="input_iam_inline_policy"></a> [iam\_inline\_policy](#input\_iam\_inline\_policy) | Json to create policy in line | `string` | `"{}"` | no |
| <a name="input_iam_managed_policy_arns"></a> [iam\_managed\_policy\_arns](#input\_iam\_managed\_policy\_arns) | List of arn policies to attached | `list(string)` | `[]` | no |
| <a name="input_iam_max_session_duration"></a> [iam\_max\_session\_duration](#input\_iam\_max\_session\_duration) | (Optional) Maximum session duration (in seconds) that you want to set for the specified role his setting can have a value from 1 hour to 12 hours. | `number` | `3600` | no |
| <a name="input_iam_name"></a> [iam\_name](#input\_iam\_name) | Friendly name of the role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value mapping of tags for the IAM role. If configured with a provider | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_arn"></a> [iam\_arn](#output\_iam\_arn) | Amazon Resource Name (ARN) specifying the role. |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | Amazon Resource Name (ARN) specifying instance profiel the role. |

## Example Usage
Here are some examples of how we can consume the module through the inputs variables.

1. **IAM Role Basic Example With Managed Policy Attached**
You can create a basic iam role with Managed Policy Attached
The iam_managed_policy_arns input param allows an array with one or more managed policies
```
  iam_name                  = local.iam_rolename
  iam_description           = local.iam_description
  iam_force_detach_policies = true
  iam_managed_policy_arns   = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  tags                      = local.tags
```

2. **Role With Inline policy** 
You can create a Iam Role with your own inline policy

    2.1 Create a new policy file (example: mypolicy.json)
    ```
    {
        "Id": "ExamplePolicy",
        "Version": "2012-10-17",
        "Statement": [
        {
            "Sid": "AllowSSLRequestsOnly",
            "Action": "s3:*",
            "Effect": "Deny",
            "Resource": [
            "arn:aws:s3:::${bucket_name}",
            "arn:aws:s3:::${bucket_name}/*"
            ],
            "Condition": {
            "Bool": {
                "aws:SecureTransport": "false"
            }
            },
            "Principal": "*"
        }
        ]
    }
    ```
    2.2 Consume the module sending as parameter the previous file with its respective parameters. 
    ```
    iam_name                  = local.iam_rolename
    iam_description           = local.iam_description
    iam_force_detach_policies = true
    input_iam_inline_policy   = templatefile("mypolicy.json", { bucket_name="my_bucket_name" })
    tags                      = local.tags
    ```

3. **Role With Trusted relationship policy**
Trust relationship – This policy defines which principals can assume the role, 
and under which conditions. This is sometimes referred to as a resource-based policy 
for the IAM role. We’ll refer to this policy simply as the ‘trust policy’. 

    3.1 You can create a file (example: assume_role_policy.json)
    ```
    {
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "${account_id}"
                    },
                    "Action": "sts:AssumeRole",
                    "Condition": {
                        "StringEquals": {
                            "sts:ExternalId": "${external_id}"
                        }
                    }
                }
            ]
        }
    ```
    3.2 Consume the module sending as parameter the previous file with its respective parameters.
    ```
    iam_name                  = local.iam_rolename
    iam_description           = local.iam_description
    iam_force_detach_policies = true
    iam_assume_role_policy    = templatefile("assume_role_policy.json", { account_id = local.account_id, external_id = local.iam_external_id})
    tags                      = local.tags
    ```

# IAM Instances Profile
An IAM Instance Profile is an AWS Identity and Access Management (IAM) entity that you can use to pass role information to an Amazon EC2 instance 
when the instance starts. It is a container for an IAM role that you can use to pass permissions to the EC2 instance, allowing it to access other 
AWS resources according to the policies attached to the role.

## Where We Can use this?
An example of usage could be in the EMR EC2 role. If you only create a simple IAM, it won't work. You must specify an Instance Profile ARN: 
https://github.com/cloudposse/terraform-aws-emr-cluster/blob/e5cf195da0b55a426517b9a0cc410d46109d2419/main.tf#L451

## How Can We Activate this?
The create_iam_instance_profile variable is a boolean flag that, when set to true, enables the creation of an IAM instance profile and associates 
it with the specified IAM role. This is particularly useful when deploying services like Amazon EMR that require an IAM instance profile for proper 
operation.

Example usage:
```
module "example_emr" {
  source                  = "path/to/your/module"
  create_iam_instance_profile = true
  # other variables and configuration
}
```
When create_iam_instance_profile is set to false, the module will not create an IAM instance profile, and you will have to provide an existing instance 
profile for the service if needed.
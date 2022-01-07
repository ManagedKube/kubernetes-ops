# Nodes
This module creates a node based on the param

It will create:
* A an EC2 instance
* attach a security group
* attach IAM policies to the instance role
* AMI used
* subnet it is placed in
* instance type

# Dependencies

`subnet_id` - the subnet to place this instance in
`aws_iam_role_policy_attachment_list` - a list of policy arn to attach to this instance

# instance_config var
This is the main input for the module.  This the EC2 instances and it's configuration.

```hcl
instance_config = {
    root_installer_device = {
      instance_type         = "m5.4xlarge"
      delete_on_termination = true,
      encrypted             = true,
      iops                  = "",
      kms_key_id            = "",
      volume_size           = 80,
      volume_type           = "gp2",
    }
    ebs_block_device = []
    user_data_inputs = {
      ebs_block_device_1_is_set       = "false"
      ebs_block_device_1_mount_path   = "null"
      ebs_block_device_2_is_set       = "false"
      ebs_block_device_2_mount_path   = "null"
    }
  }
```

# How to run the unit tests

```
cd test
go test ./
```

no cache run
```
go test ./ -v -count=1
```

## How to run the debugger

TBD

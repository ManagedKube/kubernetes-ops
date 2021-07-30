# tg-external-attach-to-vpc

This module uses one AWS accounts (#1).

## Assumptions

- AWS account #1 owns the Transit Gateway and it is already created.  The transit gateway's ARN and ID will be passed into this module.
- AWS account #1 has a VPC already created and the VPC ID will be passed into this module.

## This module will:

- AWS account #1 attaches the VPC's subnet(s) to the transit gateway

## AWS credentials

This module uses the credentials from the `./_env_defaults/transit-gateway.tfvars` file or it needs these parameters:

```
# AWS Account #1:
aws_first_access_key = "xxx"
aws_first_secret_key = "xxx"

# AWS Account #2
# aws_second_access_key = "xxx"
# aws_second_secret_key = "xxx"
```

The reason this needs two accounts is to support the external account setting when attaching a VPC to an external Transit Gateway
that belongs in another account.  While the `internal` one doesn't need this and hence it only needs one account, making this module
and the `external` module work in a similar fashion should make it easier to use both.

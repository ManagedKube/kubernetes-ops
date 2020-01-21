add-tg-routes
===============

This module adds transit gateway routes to a VPC routing table

## AWS credentials

This module uses the local shell's environment to get the AWS credentials. 

(not from the `./_env_defaults/transit-gateway.tfvars`)

If you are exporting the AWS credentials to your environment, you need at the minimum:

```
AWS_SECRET_ACCESS_KEY=xxxx
AWS_ACCESS_KEY_ID=xxxx
```
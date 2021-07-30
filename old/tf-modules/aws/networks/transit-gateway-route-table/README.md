transit-gateway-route-table
===========================

This module adds routes into the Transit Gateway's Route table for all of the destination routes this side will want to reach on the remote Transit Gateways.

If this region wants to reach any other subnets via the Transit Gateways going through this Transit Gateway then the CIDR blocks of the destinations needs to be in this list or it won't route it through this Transit Gateway.

## AWS credentials

This module uses the local shell's environment to get the AWS credentials. 

(not from the `./_env_defaults/transit-gateway.tfvars`)

If you are exporting the AWS credentials to your environment, you need at the minimum:

```
AWS_SECRET_ACCESS_KEY=xxxx
AWS_ACCESS_KEY_ID=xxxx
```
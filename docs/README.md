kubernetes-ops
==================

# Setup your IP CIDR
This document contains how your IP CIDRs are going to be laided out for your
entire infrastructure.  Care should be taken to review this and to make sure
this fits your needs.  

While getting started quick you can just go with any IP CIDR scheme just to test
it out but if you were to roll out a real world setup where people will consume
this infrastructure, not thinking this out a little bit might make it difficult
to do certain things later.  It is unfortunate that this has to come so early in
the process.  The IP CIDR is pretty much at the bottom of the stack which means
it touches everything.  Making changes to this later will probably be very difficult
and require some kind of large scale migration or cut over.

We suggest you take the `cidr-ranges.md` file as a good place to start.

# VPC Creation

Directory: <repo root>/tf-environment

## Easy route

Change directory to: 'dev-example'

Run:
```
terragrunt init
terragrunt plan
terragrunt apply
```

This will create the VPC.

## Custom production route

Copy the directory `dev-example` to a name of the environment you want to create.
If this is the first environment, `dev` is a good name.

### Update parameters
Now we have to update some parameter values in the files that we just copied in
the `dev` directory.

#### `_env_defaults/main.tf`
Update the parameter
- `environment_name` to `dev`
- `vpc_cidr` to the CIDR you chose
- `aws_availability_zone_1` and the availability zones if this needs to be updated

#### `terraform.tfvars`
This specifies where to store the Terraform remote state store.
- `bucket` - this has to be globally unique to S3.  Easiest way is to change the number to some other arbitrary number
- `key` - change `dev-example` to `dev` or whatever you named this environment to

#### `aws/vpc/main.tf`
Update the parameters:
- `public_cidrs` to the CIDR range you choose
- `private_cidrs` to the CIDR range you choose

## Launch

Run:
```
terragrunt init
terragrunt plan
terragrunt apply
```

## Post launch
The Terraform output would have given you a VPC ID

```
...
...
module.main.aws_route.private[0]: Creation complete after 1s (ID: r-rtb-015ee00a4ceb2c77b1080289494)
module.main.aws_route.private[2]: Creation complete after 1s (ID: r-rtb-0f342ec1f38c7dd7f1080289494)
module.main.aws_route.private[1]: Creation complete after 1s (ID: r-rtb-089e933a218c235121080289494)

Apply complete! Resources: 29 added, 0 changed, 0 destroyed.

Outputs:

aws_vpc_id = vpc-01262c04bc41f2f1f
```

Copy this VPC id and put it into the `_env_defaults/main.tf` file in the `vpc_id` parameter

This ID will be used by other Terraform modules/items that are launched into this VPC.

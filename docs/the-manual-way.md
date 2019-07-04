kubernetes-ops
==================
This repository represents an opinionated way to structure a repository that
holds the infrastructure level items.

# Tools you will need

See [tools.md](tools.md)

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

# Replace all of the S3 buckets used
In the examples, S3 buckets are used for Terraform and Kops as the state store.
This allows you to not hold the state of what you launched local to your machine and
on a remote machine.  This is useful if you accidentally remove the files from your
local machine or if multiple people or machines will be updating these resources.

One problem is that S3 bucket names are global meaning only one can exist.  If I
used a bucket name, that means you can not use that same name.

For you to use this, you will need to update the bucket names in this repository
to what you want to use.  We are using the bucket name `kubernetes-ops-1234-terraform-state`

The following is a way to replace all of the occurrences of `kubernetes-ops-1234-terraform-state`
with `kubernetes-ops-xxxxxx-terraform-state`.  A suggestion would be to replace the
`xxxxxx` with another random number.

Linux:
```
find . -name '*' -exec sed -i -e 's/kubernetes-ops-1234-terraform-state/kubernetes-ops-xxxxxx-terraform-state/g' {} \;
```

OSX:
```
find . -type f | xargs sed -i '' 's/kubernetes-ops-1234-terraform-state/kubernetes-ops-xxxxx-terraform-state/g'
```

You can alternatively use your IDE to search and replace this string

# VPC Creation

Directory: <repo root>/tf-environment

## Easy route

Change directory to: '<repo root>/tf-environments/dev-example/aws/vpc'

You will have to change the `bucket` in the '<repo root>/tf-environments/dev-example/aws/terraform.tfvars`
file.  S3 bucket names has to be globally unique which means it can only exist once
in the all of AWS.  The easiest way is to change the `123` in the bucket name to
some other random number.

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

We will use this ID in the Kops creation because we are putting the Kubernetes
cluster in this VPC.

# Kubernetes Cluster creation

## Change directory
From the root directory of this repo change directory to here:
```
cd clusters/aws/kops/
```

## Create an AWS EC2 key pair
This will create the key, change the permissions so you can only read it, and
add it to your shell environment for usage.

```
aws ec2 create-key-pair --key-name kubernetes_ops --query 'KeyMaterial' --output text > ./ssh-keys/kubernetes-ops.pem
chmod 400 ./ssh-keys/kubernetes-ops.pem
ssh-add ./ssh-keys/kubernetes-ops.pem
```

## Kops on AWS

Kops is an open source tool to help you create Kubernetes cluster.  We are going
to use this tool to help us create a cluster on AWS.

Source project: https://github.com/kubernetes/kops

### Download the kops tool
Using kops cli is very version specific.  This will determine what version
of Kubernetes will be installed.

We are currently using version 1.11.x.  You can download the `kops` CLI here:

https://github.com/kubernetes/kops/releases/tag/1.11.1

### Creating the cluster
There is a sample cluster named `dev-example` that you can launch as is.

Put the `vpc-id` into the file: `./clusters/dev-example/values.yaml`

Set the state store.  The kops state store is where kops writes information about
the cluster during creation.  The entire state of the cluster is here.  It
writes the information out to an AWS S3 bucket.  Since buckets are globally
unique, you need to select a name that is unique to you.  You can simply change
the `2345` string to something else or another number to make it unique.

```
export KOPS_STATE_STORE=s3://kubernetes-ops-12344-kops-state-store
```

Put the same bucket name in this case `kubernetes-ops-12344-kops-state-store` in
the file `./clusters/dev-example/values.yaml` in the `s3BucketName` values field.

Run this command to create the S3 bucket
```
aws s3api create-bucket \
    --bucket ${KOPS_STATE_STORE} \
    --region us-east-1 \
    --versioning-configuration Status=Enabled
```

Enable versioning on the bucket:
```
aws s3api put-bucket-versioning --bucket ${KOPS_STATE_STORE} --versioning-configuration Status=Enabled
```

Now, export out your AWS keys to the local shell:

```
export AWS_ACCESS_KEY_ID="foo"
export AWS_SECRET_ACCESS_KEY="bar"
export AWS_DEFAULT_REGION=us-east-1
```

You can now run this command to output the templated values:

```
kops toolbox template --template ./template/cluster.yml --values ./clusters/dev-example/values.yaml > /tmp/output.yaml
```

Run this command to create the cluster:
```
kops create -f /tmp/output.yaml
```

At this point, it just created the configs for this cluster in S3.

Get cluster name:
```
kops get clusters
```

Set the cluster name from the output
```

export cluster_name=dev-example.us-east-1.k8s.local
```

Create ssh keys to be able to ssh into the cluster.  You don't have to enter a
passphrase for the key if you do not want to.  Just hit enter.

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ./ssh-keys/id_rsa
```

Add the ssh keys into kops so it can put it on the machines.
```
kops create secret --name ${cluster_name} sshpublickey admin -i ./ssh-keys/id_rsa.pub
```

Create the cluster.  This will launch EC2 nodes and start configuring the kubernetes
cluster:
```
kops --name ${cluster_name} update cluster --yes
```

By default, kops will place the `kubeconfig` on your local system.  The kubeconfig
has information on how to reach this Kubernetes cluster and authentication for it.

It is placed in: `~/.kube/config`

#### Accessing the cluster
This cluster only has private IP addresses.  You will not be able to reach it directly.
In the `dev-example` a bastion host is created for access.

There is an easy tool to use to ssh and tunnel into a remote network called `sshuttle`

Here is the source project:  https://github.com/sshuttle/sshuttle

There are binaries and installs for Windows, OSX, and Linux.

Using this you would run the this command to tunnel traffic to this VPC.

In the AWS console find the load balancer that is pointed to the bastion host.  In the
EC2 Dashboard, got to "Load Balancer" and search for "bastion".  The DNS name will
point to your bastion host:

DNS name: bastion-dev-example-us-ea-3gprsr-2140616004.us-east-1.elb.amazonaws.com

Add the ssh private key you just generated to your local store so you can ssh in:
```
ssh-add ./ssh-keys/kubernetes-ops.pem
```

Run the sshuttle command:
```
sshuttle -r ec2-user@bastion-dev-example-us-ea-3gprsr-2140616004.us-east-1.elb.amazonaws.com 10.10.0.0/16 -v
```

This will forward all traffic destined for `10.10.0.0/16` through this tunnel.

In another shell, run a `kubectl` command to check connectivity:

```
kubectl get nodes
```

# References

Kops setup: https://github.com/kubernetes/kops/blob/master/docs/aws.md

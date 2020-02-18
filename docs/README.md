kubernetes-ops
==================


# The cloud
Every cloud has a concept of a "network".  AWS and GCP calls it the VPC.  The VPC
will hold everything that you will ever run or create in the cloud.  Items such as instances,
subnets, firewall rules, databases, queues, load balancers, etc.  Since it is
such a foundational piece that sits at pretty much the bottom of the stack it
is very important to get this correct because trying to make changes to this laster
with everything running on it could turn out to be very difficult or impossible
without downtime and/or a lot of reconfiguration of items that are running in
this VPC.

We also want to take control of creation and managing this VPC exclusively.  A lot
of tools that creates Kubernetes clusters for you has the option of creating the
VPC, subnets, NATs, etc for you but in practice this is generally a bad idea.  If
Kubernetes was the only item in this VPC, then that is ok but usually we don't just
run a Kubernetes cluster.  Our workload/application will want to use cloud databases
such as RDS, SQS, Lambda, other instances that are not Kubernetes nodes, etc.  We
will need to create subnets and other items for them to live in.  For that reason
we create our own VPC and tell the Kubernetes cluster to use our VPCs and our
settings (and not the other way around).

## CIDR / IP Scheme
This is probably one of the most important decision when getting started.  What
will my IP scheme be?  Not thinking about this in the beginning can have big
repercussions down the road.  If you use the same CIDR for two VPC now and sometime
in the future you want to peer them so that the two VPC can communicate with each
other directly, you are pretty much out of luck here.  You will either need to
re-IP one of the VPCs (which sounds like a lot of work) or setup a NAT between
them and translate (which also sound like a lot of work) instead of a 30 minute
peering job, it turns into days if not more for the alternatives.

We might think that in this day and age, we don't need to worry about IPs.  I
wish we were.  This is the underpinning of the entire infrastructure.

This is why we have setup a CIDR/IP Scheme for you that you can use.  

[cidr-ranges.md](cidr-ranges.md)

# What does the stack look like?

<put picture of the stack, orange pic>

# Tools you will need
[tools.md](tools.md)

# Setting up the S3 buckets
In the configs, S3 buckets are used for Terraform and Kops as the state store.
This allows you to not hold the state of what you launched local to your machine and
on a remote machine.  This is useful if you accidentally remove the files from your
local machine or if multiple people or machines will be updating these resources.

One problem is that S3 bucket names are global meaning only one can exist.  If I
used a bucket name, that means you can not use that same name.

For you to use this, you will need to update the bucket names in this repository
to what you want to use.  We are using the bucket name `kubernetes-ops-1234-terraform-state`

The following is a way to replace all of the occurrences of `kubernetes-ops-1234`
with `kubernetes-ops-xxxxxx`.  A suggestion would be to replace the
`xxxxxx` with another random number.  Try `123456` or `333333`, etc.

Linux:
```
find . -name '*' -exec sed -i -e 's/kubernetes-ops-1234/kubernetes-ops-xxxxxx/g' {} \;
```

OSX:
```
find . -type f | xargs sed -i '' 's/kubernetes-ops-1234/kubernetes-ops-xxxxxx/g'
```

You can alternatively use your IDE to search and replace this string

## Create the S3 buckets for Terraform
Terraform will create it's own bucket during the Terraform run.  It will ask you
if you want to create it.

## Create the S3 buckets for kops
You will have to create the S3 bucket that Kops uses manually.

```
export KOPS_S3_BUCKET=kubernetes-ops-xxxxxx-kops-state-store
```

Run this command to create the S3 bucket
```
aws s3api create-bucket \
    --bucket ${KOPS_S3_BUCKET} \
    --region us-east-1
```

Enable versioning on the bucket:
```
aws s3api put-bucket-versioning --bucket ${KOPS_S3_BUCKET} --versioning-configuration Status=Enabled
```

Using default encryption:
```
aws s3api put-bucket-encryption --bucket ${KOPS_S3_BUCKET} --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
```

# Environments

Environments are a self contained VPC for your application.  Usually you would have
at least a `dev` and a `prod` environment if not a full series from `dev` ->
`qa` -> `staging` -> `prod`.

Ideally each environment are mostly the same.  It is created via the same method,
has the same items in it, operates the same way, updated the same way, runs the
same infrastructure and application in it.

The difference usually are the the sizes of the nodes, data stores, numbers of nodes.
For example, `dev` might be a 3 node cluster while `prod` might be double that to
account for high availability or extra load on the systems.

Another difference might be security levels or access.  In the `dev` or `qa`
environments, there is no customer data, no private data of any kind which means
generally any developer can have access to it without much worries.  On a `prod`
environment running live applications that your customers interact with and putting
personal information onto, these systems might be a little bit more sensitive and
not everyone has access to it.  Depending on your requirements, you might limit
access or even have to go through some approvals to get access to any parts of this
infrastructure.

why so many?

By doing this you have environments like `dev` where developers and delivering
new application code into it while they are working and testing it.  This code
can be not fully functional and tested.  You want this environment and other non
`prod` environments to vet out the code before your end customer uses it.

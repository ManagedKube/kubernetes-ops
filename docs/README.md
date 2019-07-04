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

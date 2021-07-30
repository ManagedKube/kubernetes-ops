RDS
==============
This module creates a single instance of an AWS RDS resource.

It also creates all auxiliary items (subnets, security groups, etc) this resource needs to run in a VPC.  By
creating all resources the RDS needs to run in oppose to piggy backing on
other resources, it allows us to change this resource and it's "world" without
affecting other resources.  This allows us to perform CRUD operations in an
isolated fashion against this resource.

This resource has it's subnets published in the [cidr-range.md](../../cidr-range.md) document.

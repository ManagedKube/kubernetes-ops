SSM VPC Endpoints
====================
The regular way that SSM works is that there is an SSM Agent installed onto the EC2 instance.  This SSM Agent reaches out to the AWS SSM endpoint which is on the public internet to start the connection to the SSM Manager which is basically a control channel into this EC2 instance.  If you do not want this and want it to instead go instead to an internal endpoint, you have to create a VPC endpoint with the SSM service.


https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/

Note: These endpoints cost about $7/month.

## Network ACL Rules
If Network ACL rules are placed onto the VPC, you will need to add an allow rule to allow the local CIDR range.  If that is not added, that will block access from the EC2 instance to the private VPC endpoints.

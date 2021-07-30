# GCP Private GKE VPC module

This module is used to set up a VPC as well as a few basic networking components
for a private GKE cluster with no public IPs on the GKE master and nodes.  This module
should be restricted to content that is considered 'core' to setting up a VPC and basic subnets,
in most cases additional networking logic (e.g. firewall rules, routes) will need to be created on top
of this.

This module sets up the following resources:

- A VPC (known as a google_compute_network)
- A public subnet and a private subnet, each of which is allocated a /24 subnet
- Secondary IP ranges that are required for a private GKE cluster
- A reserved IP address for a NAT instance
- A NAT instance
- A firewall rule allowing ssh traffic from a bastion server
- A firewall rule for the NAT to allow passthrough traffic
- A route for instances on the private subnet to proxy traffic through the NAT

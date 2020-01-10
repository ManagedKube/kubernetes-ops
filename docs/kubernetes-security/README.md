# Kubernetes Security
This page is here to describe security challenages and possible solutions to various security concerns in a 
Kubernetes deployment.

## Traditional n-tier archtecture
This diagram represents a non-containerized n-tier architecture:

![the stack](/docs/kubernetes-security/images/n-tier-application-architecture.png)

### [1] Internet
The Internet is the Internet in general.  Items placed here can be reach by any node on the Internet.

### [2] Internal Network
The internal network is a network that has IPs in the [RFC 1918](https://tools.ietf.org/html/rfc1918) ranges.  These IPs are not routable via the internet.
The hosts in this network will need something like a load balancer with a public IP and an private IP in this network to get traffic inbound from the internet.
If these nodes want to connect to other hosts on the Internet, it will need to go through something like a NAT gateway (which will have a public IP and a
private IP) to reach these external hosts.

The internal network is where instances for the application will reside.  Usually not every single machine and not the entire machine needs to be reachable by
the internet to serve out an application.  Usually only the HTTP/HTTPS (80/443) ports needs to be exposed for a web application to function properly.  This means
there is no need to expose the entire machine to the internet and the application can only expose a certain set of ports which makes it much safer because the
attack surface for this application will be only 2 ports.

### [3] Loadbalancer
The load balancer has a public IP address that is reachable anywhere on the internet.  This is the main point of entry for the application.  The load balancer
bridges the external network (Internet) and the internal private network where the application servers resides.

This is a vulnerable point since it is on the internet and anyone can reach it.  The job of the load balancer is to forward traffic from the internet to a set
of redundant servers we have internally that is handling request for the application.  This also means that the "web tier" servers are vulnerable to attacks
from the outside.

### [4] Bastion host
The bastion host has a public IP address that is reachable anywhere on the internet and a private IP address for the internal network.  The bastion host bridges
the external network (Internet) and the internal private network where the application servers resides.

This is a vulnerable point since it is on the internet and anyone can reach it.  While this machine does not blindly forward traffic from the internet into our backend servers, it is most likely sitting on a well known SSH port 22.  We can limit the IPs that can reach this port but it is still sitting on the internet and
it would be something to watch out for.

This host is very important since it is bridging the internet and the internal network and it is a full Linux system.  If someone is able to compromise this host,
they would have a whole suite of tools available to them to further attack the internal network.

### [5] VPN
This might be a duplicate node but wanted to highlight that it might be here.  The VPN will serve about the same purpose as the bastion host.  The VPN has a
public IP address and an internal IP address spanning the two networks.  It has similar vulnerabilities as the bastion host but maybe a little less.  These are
usually appliances which has limited functionality and are hardend for security.  However, this is again just software and over the years, there has been numerous
remotely exploitable vulnerabilities against top VPN vendors.

### [6] Availability zones
In this particular example there are two availability zones.  These are usually physical segments of the network where each availability zone is isolated in a sense where a zone can have it's own power, racks, routers, switches, and servers.  This means that if there is a physical problem or a configuration issue on these set of items, it will only affect this zone.  The other zone(s) should be still good.

In this setup, we are using 2 zones and the load balancer is pointed to both zones and we have the same servers one in each zone for high availability and
redundancy.

### [7] Web tier subnet
The web tier holds the externally facing web servers.  This is the only subnet that the load balancers are pointed to and to specific servers sitting on specific
set of ports.
* This subnet has access control rules (ACLs) to allow traffic from the load balancer to it's servers in this subnet
* Ther are no other inbound traffic that is allowed into this subnet (except for management traffic)

### [8] Business tier
The business tier is just one or more set(s) of subnets and server(s) that does backend work.  These items are not exposed externally that has an external load balancer pointed to it.  This set of workload provides support functionality to the application.  This could be supporting the web tier to retrieve some information or it could be
a set of batch jobs that runs on some interval to crunch data.  

The picture depicts one subnet in each zone but it could be a bunch of different subnets with different types of workload(s) living in it.  The main point
here is that these set of servers are isolated from the internet and has no direct connections.  Further more, it can have only limited connections inbound
to it.  If this set of servers only serves the web tier, then inbound traffic should only be able to come from the web tier.  If there are additional business
tier that does a batch job and it doesnt need any incoming connections and all it needs is to go and fetch data from the database, it might not allow any
incomming connections to it (except for management traffic).

### [9] Datastore
The datastore tier is one or more set of subnets and servers that provide data storage functionality.  These can be databases, object stores, NoSQL clusters, etc.
Since the datastores is where a lot of valuable information is kept, it is usually isolated off and monitored heavily.  It has tight controls on what can connect
to it.

## Control plane

![the stack](/docs/kubernetes-security/images/kubernetes-controle-plane.png)

### 1
All pieces communicates with the Kubernetes API via the same interface through a RESTful API.

## Example application

![the stack](/docs/kubernetes-security/images/example-application.png)

### 1
This is the only external entry point into the Kubernetes cluster from the internet.

## Deployment workflow

![the stack](/docs/kubernetes-security/images/deployment-workflow.png)
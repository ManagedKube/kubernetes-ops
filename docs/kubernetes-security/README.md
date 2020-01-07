# Kubernetes Security
This page is here to describe security challenages and possible solutions to various security concerns in a 
Kubernetes deployment.

## Traditional n-tier archtecture
This diagram represents a non-containerized n-tier architecture:

![the stack](/docs/kubernetes-security/images/n-tier-application-architecture.png)

### [1] Loadbalancer
The load balancer has a public IP address that is reachable anywhere on the internet.  This is the main point of entry for the application.  The load balancer
bridges the external network (Internet) and the internal private network where the application servers resides.

This is a vulnerable point since it is on the internet and anyone can reach it.  The job of the load balancer is to forward traffic from the internet to a set
of redundant servers we have internally that is handling request for the application.  This also means that the "web tier" servers are vulnerable to attacks
from the outside.

### [2] Bastion host
The bastion host has a public IP address that is reachable anywhere on the internet and a private IP address for the internal network.  The bastion host bridges
the external network (Internet) and the internal private network where the application servers resides.

This is a vulnerable point since it is on the internet and anyone can reach it.  While this machine does not blindly forward traffic from the internet into our backend servers, it is most likely sitting on a well known SSH port 22.  We can limit the IPs that can reach this port but it is still sitting on the internet and
it would be something to watch out for.

This host is very important since it is bridging the internet and the internal network and it is a full Linux system.  If someone is able to compromise this host,
they would have a whole suite of tools available to them to further attack the internal network.

### [3] VPN
This might be a duplicate node but wanted to highlight that it might be here.  The VPN will serve about the same purpose as the bastion host.  The VPN has a
public IP address and an internal IP address spanning the two networks.  It has similar vulnerabilities as the bastion host but maybe a little less.  These are
usually appliances which has limited functionality and are hardend for security.  However, this is again just software and over the years, there has been numerous
remotely exploitable vulnerabilities against top VPN vendors.

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
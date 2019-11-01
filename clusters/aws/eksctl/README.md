eksctl
=========

Source project docs:  https://eksctl.io

This is a great page on the schema of the config files and options available when creating the cluster:
https://github.com/weaveworks/eksctl/blob/master/site/content/usage/20-schema.md

# Making the Kubernetes API a private endpoint

Current this is not supported via CloudFormation and since `eksctl` uses Cloudformation to bring up
a cluster, it currently cannot set this setting.

Ticket tracking this issue: https://github.com/weaveworks/eksctl/issues/649

As a work around, you can manually go to the AWS EKS console and change the endpoint type.

# Export your AWS keys to your local shell
eksctl will use these to interact with your AWS account.

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=us-east-1
```

# Creating a cluster

```
eksctl create cluster -f config.yaml
```

# sshuttle into the environment

```
sshuttle -r ec2-user@bastion-dev2-us-east-1-k8-1spe3s-1338509712.us-east-1.elb.amazonaws.com 172.17.0.0/16 -v --dns
```

You will need the `--dns` option to be able to resolve the Kubernetes API's endpoint.


# Creating an ingress controller
The install of it went fine

However, the serice Type: LoadBalancer could not create an ELB:

```
  Warning  CreatingLoadBalancerFailed  19s (x3 over 34s)  service-controller  Error creating load balancer (will retry): failed to ensure load balancer for service ingress/external-nginx-ingress-controller: could not find any suitable subnets for creating the ELB
```

This is probably due to the fact that none of the public subnets has the `KubernetesCluster` tag with the name
of this cluster in it so this Kube cluster don't know which subnet to put the external ELB into.


# Deleting

## Deleting a node group

```
eksctl delete nodegroup  --cluster gar-test --name ng-1
```

## Deleting the cluster

```
eksctl delete cluster gar-test
```
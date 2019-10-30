eksctl
=========

Source project docs:  https://eksctl.io




# Making the Kubernetes API a private endpoint

Current this is not supported via CloudFormation and since `eksctl` uses Cloudformation to bring up
a cluster, it currently cannot set this setting.

Ticket tracking this issue: https://github.com/weaveworks/eksctl/issues/649

As a work around, you can manually go to the AWS EKS console and change the endpoint type.


# Creating a cluster

```
eksctl create cluster -f config.yaml
```
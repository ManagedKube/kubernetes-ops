# EKS

## EKS permissions

For each EKS cluster you want to access you will need to add your user to the list of people that has access.

For `staging` it is located here: `<repo root>/terraform-environments/aws/staging/20-eks/main.tf`

Under these keys:
* `map_roles`
* `map_users`

## Local setup to access an EKS cluster

### Install
On your local computer, you will need to setup your credentials to authenticate to the EKS cluster via the cli tools

Required local CLI tools:
* AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
* kubectl - https://kubernetes.io/docs/tasks/tools/#kubectl

### AWS Authentication
The CLI tool `kubectl` uses a config file called the `kubeconfig` to tell it where the Kubernetes API endpoint is and how to authenticate to it.  Since EKS is on AWS, the `aws` CLI tool can help you to produce this file and place it locally on your system.  By default, running the following commands will place the config file on your system at this path: `~/.kube/config`.  You can override this path by setting the envar `KUBECONFIG`.  The CLI `kubectl` will first read this envar to find the location of the `kubeconfig` and then default back to `~/.kube/config` path.

List the EKS clusters:
```
aws eks --region us-east-1 list-clusters
```

Get the `kubeconfig` of a cluster:
```
aws eks --region us-east-1 update-kubeconfig --name <cluster name>
```

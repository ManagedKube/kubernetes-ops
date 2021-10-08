# **Helm Troubleshooting -> ingress-nginx-external**

## **Steps**
Assuming all the workspaces in Terraform Cloud are created and working with their associated environments, these commands are executed in CLI.

**10-vpc**
```
terraform init
terraform apply
```

Output:
```
Apply complete! Resources: 37 added, 0 changed, 0 destroyed.
```

**20-eks**
```
terraform init
terraform apply
```

Output:
```
Apply complete! Resources: 28 added, 0 changed, 0 destroyed.
```

**ingress-nginx-external**
```
terraform init
terraform apply
```

Initial (Before [kubernetes-ops](https://github.com/ManagedKube/kubernetes-ops) Repo Update)

Output:
```
Warning: Helm release "ingress-nginx" was created but has a failed status. Use the `helm` command to investigate the error, correct it, then run Terraform again.

with module.ingress-nginx-external.helm_release.helm_chart,
on .terraform/modules/ingress-nginx-external/terraform-modules/aws/helm/helm_generic/main.tf line 1, in resource "helm_release" "helm_chart":
1: resource "helm_release" "helm_chart" {



Error: timed out waiting for the condition

with module.ingress-nginx-external.helm_release.helm_chart,
on .terraform/modules/ingress-nginx-external/terraform-modules/aws/helm/helm_generic/main.tf line 1, in resource "helm_release" "helm_chart":
1: resource "helm_release" "helm_chart" {
```

Current (After [kubernetes-ops](https://github.com/ManagedKube/kubernetes-ops) Repo Update)

*Specifically from updates with these PRs:*
+ [#189 -- Creating VPC](https://github.com/ManagedKube/kubernetes-ops/pull/189)
+ [#190 -- Creating EKS cluster](https://github.com/ManagedKube/kubernetes-ops/pull/190)
+ [#195 -- Adding nginx-ingress](https://github.com/ManagedKube/kubernetes-ops/pull/195)


Output:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## **Additional Commands**

Command:
```
kubectl get pods -A
```

Output:
```
NAMESPACE       NAME                                        READY   STATUS      RESTARTS      AGE
ingress-nginx   ingress-nginx-admission-create--1-bjcnw     0/1     Completed   0             3d
ingress-nginx   ingress-nginx-admission-patch--1-vqjmm      0/1     Completed   0             3d
ingress-nginx   ingress-nginx-controller-69bdbc4d57-dgdqz   0/1     Running     1 (27s ago)   3d
kube-system     coredns-78fcd69978-8t6t7                    1/1     Running     1 (27s ago)   3d
kube-system     etcd-minikube                               1/1     Running     0             3d
kube-system     kube-apiserver-minikube                     1/1     Running     1 (27s ago)   3d
kube-system     kube-controller-manager-minikube            1/1     Running     0             3d
kube-system     kube-proxy-lqxh5                            1/1     Running     1 (27s ago)   3d
kube-system     kube-scheduler-minikube                     1/1     Running     1 (27s ago)   3d
kube-system     storage-provisioner                         1/1     Running     4 (27s ago)   3d
```

Command:
```
kubectl get services
```

Output:
```
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d
```

## **AWS ELB**

+ Navigate to EC2
+ Click Load Balancing on the Left Navigation Pane
+ Click Load Balancers
+ Select listed Load Balancer -> example: `a01865d9b088d41fab65d40e685feef0`
+ Select `Description` tab
+ Highlight and select `DNS Name` -> [a01865d9b088d41fab65d40e685feef0-1272672672.us-east-1.elb.amazonaws.com](a01865d9b088d41fab65d40e685feef0-1272672672.us-east-1.elb.amazonaws.com)
+ Output is website with `nginx 404 Not Found`
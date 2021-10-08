# **Helm Troubleshooting**
Instantiating Ingress Nginx in Helm through Terraform Cloud does not provide an external IP for AWS ELB. Below are commands I've used to recreate the problem.

## **Setup**
Make sure to have these tools installed on your machine:
+ `kubectl`: https://kubernetes.io/docs/tasks/tools
+ `minikube`: https://minikube.sigs.k8s.io/docs/start
+ `helm`: https://helm.sh/docs/intro/install

Use this guide for initial setup in Terraform Cloud: https://github.com/ManagedKube/kubernetes-ops/blob/main/docs/terraform-github-action-pipeline.md

Use this guide to get access to your kubernetes cluster: https://github.com/ManagedKube/kubernetes-ops/tree/main/terraform-environments/aws/dev/20-eks#aws-cli-authentication


## **Steps**
Assuming initial setup above has taken place, here are the commands used in CLI to recreate the problem.

### **Create the VPC**

Path: `terraform-environments/aws/dev/10-vpc`

Workflow:
```
terraform init
terraform apply
```

Output:
```
...

Apply complete! Resources: 37 added, 0 changed, 0 destroyed.
```

### **Create the EKS cluster**

Path: `terraform-environments/aws/dev/20-eks`

Workflow:
```
terraform init
terraform apply
```

Output:
```
...

Apply complete! Resources: 28 added, 0 changed, 0 destroyed.
```

### **Add Ingress Nginx**

Path: `terraform-environments/aws/dev/helm/ingress-nginx-external`

Workflow:
```
terraform init
terraform apply
```

Initial Output (Before [kubernetes-ops](https://github.com/ManagedKube/kubernetes-ops) Repo Update):
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

Current Output (After [kubernetes-ops](https://github.com/ManagedKube/kubernetes-ops) Repo Update):

```
...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Note: *For more detail on what got updated in the repo, these are the PRs for this particular use case:*
+ [#189 -- Creating VPC](https://github.com/ManagedKube/kubernetes-ops/pull/189)
+ [#190 -- Creating EKS cluster](https://github.com/ManagedKube/kubernetes-ops/pull/190)
+ [#195 -- Adding nginx-ingress](https://github.com/ManagedKube/kubernetes-ops/pull/195)

### **List Pods using Kubectl**

Workflow:
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

### **List Kubernetes Services using Kubectl**
Workflow:
```
kubectl get services
```

Output:
```
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d
```

As you may notice from the last two commands, it seems as though `nginx` is running, but somehow there is no `EXTERNAL-IP` to verify if it is. At the very least there should be an `EXTERNAL-IP` to paste into the browser for an `nginx 404 Not Found` webpage.

Any ideas on how to address this?
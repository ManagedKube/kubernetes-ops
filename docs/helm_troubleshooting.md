# **Helm Troubleshooting**
Instantiating Ingress Nginx in Helm through Terraform Cloud does not provide an `EXTERNAL-IP` for AWS ELB. The `kubectl get services` command shows `<none>` below `EXTERNAL-IP` (output shown near the end of this document). Steps and commands shown below are used to recreate the problem.

## **Setup**
Make sure to have these tools installed on your machine:
+ `kubectl`: https://kubernetes.io/docs/tasks/tools
+ `minikube`: https://minikube.sigs.k8s.io/docs/start
+ `helm`: https://helm.sh/docs/intro/install

Use this guide for initial setup in Terraform Cloud: https://github.com/ManagedKube/kubernetes-ops/blob/main/docs/terraform-github-action-pipeline.md

Use this guide to get access to your Kubernetes Cluster: https://github.com/ManagedKube/kubernetes-ops/tree/main/terraform-environments/aws/dev/20-eks#aws-cli-authentication


## **Steps**
Assuming the setup above has taken place, here are the steps and commands used in CLI to recreate the problem.

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

As you may notice from the last two commands, it seems as though `ingress-nginx` is running, but somehow there is no `EXTERNAL-IP` to verify if it is. At the very least there should be an `EXTERNAL-IP` to copy and paste into the browser for an `nginx 404 Not Found` webpage.

Any ideas on how to fix this?
<br>
<br>
### **Attempted Solution**

It has been suggested that I'm using a minikube cluster which is not a cloud solution since it's for local use only. This is true, I am using minikube, however I've found a workaround to have an `EXTERNAL-IP` from the created `LoadBalancer` service. The commands below are given to show a more detailed output of what's going on.

Workflow:
```
kubectl get pods -A
```

Output:
```
NAMESPACE       NAME                                        READY   STATUS      RESTARTS       AGE
ingress-nginx   ingress-nginx-admission-create--1-bjcnw     0/1     Completed   0              6d9h
ingress-nginx   ingress-nginx-admission-patch--1-vqjmm      0/1     Completed   0              6d9h
ingress-nginx   ingress-nginx-controller-69bdbc4d57-dgdqz   1/1     Running     1 (3d9h ago)   6d9h
kube-system     coredns-78fcd69978-8t6t7                    1/1     Running     1 (3d9h ago)   6d9h
kube-system     etcd-minikube                               1/1     Running     1 (3d9h ago)   6d9h
kube-system     kube-apiserver-minikube                     1/1     Running     1 (3d9h ago)   6d9h
kube-system     kube-controller-manager-minikube            1/1     Running     1 (3d9h ago)   6d9h
kube-system     kube-proxy-lqxh5                            1/1     Running     1 (3d9h ago)   6d9h
kube-system     kube-scheduler-minikube                     1/1     Running     1 (3d9h ago)   6d9h
kube-system     storage-provisioner                         1/1     Running     6 (14h ago)    6d9h
```

Workflow:
```
kubectl get services
```

Output:
```
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   6d9h
```

Workflow:
```
kubectl -n ingress-nginx get services
```

Output:
```
NAME                                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort    10.105.38.193   <none>        80:30443/TCP,443:32508/TCP   6d9h
ingress-nginx-controller-admission   ClusterIP   10.111.30.49    <none>        443/TCP                      6d9h
```

Workflow:
```
kubectl -n ingress-nginx describe service ingress-nginx-controller
```

Output:
```
Name:                     ingress-nginx-controller
Namespace:                ingress-nginx
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/name=ingress-nginx
Annotations:              <none>
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.105.38.193
IPs:                      10.105.38.193
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  30443/TCP
Endpoints:                172.17.0.3:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  32508/TCP
Endpoints:                172.17.0.3:443
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

Workflow:
```
kubectl -n ingress-nginx describe service ingress-nginx-controller-admission
```

Output:
```
Name:              ingress-nginx-controller-admission
Namespace:         ingress-nginx
Labels:            app.kubernetes.io/component=controller
                   app.kubernetes.io/instance=ingress-nginx
                   app.kubernetes.io/name=ingress-nginx
Annotations:       <none>
Selector:          app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.111.30.49
IPs:               10.111.30.49
Port:              https-webhook  443/TCP
TargetPort:        webhook/TCP
Endpoints:         172.17.0.3:8443
Session Affinity:  None
Events:            <none>
```

All shown IPs above were tested in the browser and each continuously loaded until there is a timeout error.

Yet this [article](https://blog.codonomics.com/2019/02/loadbalancer-support-with-minikube-for-k8s.html) shows a few different workarounds to get a `LoadBalancer` running locally with minikube. The easiest command I've found to work best is: `minikube service list`

Workflow:
```
minikube service list
```

An alternative command would be: `minikube service <name> -n <namespace> --url`

Output:
```
|---------------|------------------------------------|--------------|---------------------------|
|   NAMESPACE   |                NAME                | TARGET PORT  |            URL            |
|---------------|------------------------------------|--------------|---------------------------|
| default       | kubernetes                         | No node port |                           |
| ingress-nginx | ingress-nginx-controller           | http/80      | http://192.168.64.4:30443 |
|               |                                    | https/443    | http://192.168.64.4:32508 |
| ingress-nginx | ingress-nginx-controller-admission | No node port |                           |
| kube-system   | kube-dns                           | No node port |                           |
|---------------|------------------------------------|--------------|---------------------------|
```

Workflow:
```
minikube service ingress-nginx-controller -n ingress-nginx --url
```

Output:
```
http://192.168.64.4:30443
http://192.168.64.4:32508
```

Pasting one or both URLs into the browser will finally give you the `nginx 404 Not Found` page. Though make sure to type `https` on the second URL listed.
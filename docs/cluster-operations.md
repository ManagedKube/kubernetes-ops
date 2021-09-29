# Cluster operations

## How to install and upgrade the certs
Currently there are not certificates to install or update

## the IAM provisioning - what policies and roles are setup and how will it be maintained

### EKS cluster
The EKS cluster uses roles and policies.  The EKS module handles it's own requirements internally to the module and we as users of this module don't need to specifically worry about what roles and policies it needs.

### Access to the EKS clusters
The EKS cluster defines a set of roles and users that can be mapped into the EKS cluster:  https://github.com/ManagedKube/kubernetes-ops/blob/main/terraform-environments/aws/dev/20-eks/main.tf

```
  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::725654443526:user/username"
      username = "username"
      groups   = ["system:masters"]
    },
  ]
```

These roles are mapped from an AWS IAM user into the EKS cluster's groups and from there we can define Kubernetes RBAC policies on what a user can do or not.

Kubernetes RBAC documentation: https://kubernetes.io/docs/reference/access-authn-authz/rbac/

## How to scale up or scale down a POD
This is done by setting the `replicaCount` in each of the application deployment file.

For example for `nginx-ingress`, you would change the number of replica count here: https://github.com/ManagedKube/kubernetes-ops/blob/main/terraform-environments/aws/dev/helm/40-ingress-nginx-external/helm_values.tpl.yaml

This determines how many pods will run in this environment for this service.

## Restarting a POD
To restart a pod, you will have to use the `kubectl` command line tool.

First list the pods:

```bash
kubectl get pods

NAME                                           READY   STATUS    RESTARTS   AGE
my-app1-8584f857df-kgfpg                       2/2     Running   0          30m
my-app1-bdc4894d8-ggtx8                        2/2     Running   0          4d15h
my-app2-86b5968549-slsdb                       2/2     Running   0          64m
 
```

Select one to restart by deleting it:
```bash
kubectl delete pods my-app1-8584f857df-kgfpg
```

## How to give a pod certain IAM role/permissions
Running in Kubernetes allows you to associate an IAM role to a pod.  This allows you to give a pod and the containers within it certain permissions to your AWS cloud.  This is the same mechanism as associating an IAM role to an EC2 instance.  Since a pod can run on any number of nodes in the cluster and the nodes are running multiple pods, for most access, you most likely do not want to give every pod running on the node the same access.  This allows you to selectively provide access to the pod that needs it.

Documentation: https://docs.aws.amazon.com/eks/latest/userguide/specify-service-account-role.html

Here is an example the the EKS cluster-autoscaler.  The cluster-autoscaler needs access to the AWS ASG (auto scaling groups) so that it can scale the number of nodes in the cluster up and down based on it's needs.  It needs to do perform activities such as listing the nodes in the ASG group and being able to make changes to it.

Here is the cluster-autoscaler module: https://github.com/ManagedKube/kubernetes-ops/tree/main/terraform-modules/aws/cluster-autoscaler

We'll go through some parts of this config.

```
module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "cluster-autoscaler-${var.cluster_name}"
  provider_url                  = replace(var.eks_cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler-${var.cluster_name}"
  description = "EKS cluster-autoscaler policy for cluster ${var.eks_cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
...
...
...
```

We are creating a policy and then a role that binds this policy to it.

In the cluster-autoscaler's Helm chart we give it the kubernetes service account that we want this pod to use which has the AWS identity mapped to the authorizing this user/service account and then we add in the annotation of the role that we want to assume.
```yaml
rbac:
  create: true
  serviceAccount:
    # This value should match local.k8s_service_account_name in locals.tf
    name: ${serviceAccountName}
    annotations:
      # This value should match the ARN of the role created by module.iam_assumable_role_admin in irsa.tf
      eks.amazonaws.com/role-arn: "arn:aws:iam::${awsAccountID}:role/cluster-autoscaler-${clusterName}"
```

Suffice it to say, all of these names has to match up exactly or the authentication will fail.


## How to give a pod access to the RDS database via a pod IAM role?

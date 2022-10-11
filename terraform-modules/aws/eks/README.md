# eks

Builds and EKS cluster using this module: https://github.com/terraform-aws-modules/terraform-aws-eks

## Post cluster creation

list clusters
```
aws eks --region us-east-1 list-clusters
```

Get kubeconfig
```
aws eks --region us-east-1 update-kubeconfig --name eks-dev
```

## aws-auth config map
Due to the changes in how the AWS EKS module works, the module is not applying the aws-auth's configmap anymore.  This means we have to apply it.  


If using Github Actions to run this module, you will have to download `kubectl` into the pipeline.
```
      - name: 'Download kubectl'
        run: |
          curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
          chmod 755 kubectl
          cp kubectl ${{ github.workspace }}/tmp_bin/kubectl
```

Then set this input parameter:
```
kubectl_binary = "/github/workspace/kubectl"
```

## Granting permissions to kubectl
Using `kubectl` with an EKS cluster authenticates with AWS IAM.  The creator of the EKS cluster will be granted permission to the cluster on creation.  This is essentially the first user on the cluster.  For other AWS users or users that assumes IAM roles, these users/roles will have to be added into the list.

Without adding in any user/roles to the cluster when running `kubectl` commands the user will be denied:
```
kubectl get pods
error: You must be logged in to the server (Unauthorized)
```

You can go to: `AWS Console -> CloudWatch -> Logs -> Log groups -> /aws/eks/<cluster name>/cluster`

There is a log stream named: `authenticator-XXXXXXX`

This log stream holds the logs for the Kubernetes aws-auth pod running in this cluster that is doing the authentication.  You can search the logs for denied messages such as:

```
time="2022-10-11T18:10:41Z" level=info msg="STS response" accesskeyid=ASIAW5Y4UBHMUKVMVAAA accountid=476264531111 arn="arn:aws:sts::47626451111:assumed-role/AWSReservedSSO_devops_admin_595c0f4da82205f0/gkan@example.com" client="127.0.0.1:36738" method=POST path=/authenticate session=gkan@example.com userid=AROAW5Y4UBHMR662MVVH4
```

The key item to find in there is the role and in this specific log is:
```
role/AWSReservedSSO_devops_admin_595c0f4da82205f0
```

You will then have to go into the `AWS Console -> IAM -> Roles` and search for `AWSReservedSSO_devops_admin_595c0f4da82205f0`.  When you find this role, you can click on the details of it and copy the AWS ARN.

In this case it is: `arn:aws:iam::476264531111:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_devops_admin_595c0f4da82205f0`

You will then add this user or role to the appropriate section in the Terragrunt/Terraform instantiation of it: https://github.com/ManagedKube/kubernetes-ops/blob/main/terraform-environments/aws/terragrunt-dev/us-east-1/terragrunt-dev/200-eks/terragrunt.hcl

It seems that you have to remove everything in between the `role` and role name.  Remove `/aws-reserved/sso.amazonaws.com`.  Which will give you:

```
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::476264531111:role/AWSReservedSSO_devops_admin_595c0f4da82205f0"
      username = "devops-admin"
      groups   = ["system:masters"]
    },
 ```
 
 


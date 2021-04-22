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

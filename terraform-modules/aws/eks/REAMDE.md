# eks

Builds and EKS cluster

## Post cluster creation

list clusters
```
aws eks --region us-east-1 list-clusters
```

Get kubeconfig
```
aws eks --region us-east-1 update-kubeconfig --name eks-dev
```

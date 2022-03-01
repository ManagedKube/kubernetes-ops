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

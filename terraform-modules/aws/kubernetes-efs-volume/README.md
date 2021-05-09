# kubernetes-efs-volume

Depends on the `eks-efs-csi-driver` module to be instantiated in the cluster first.

This module will:
* Create an AWS EFS resource with the appropriate security group and IAM permisisons
* Create a persistent volume (pv) pointing to this EFS endpoint
* Create a persistent volume claim (pvc) pointing to the `pv`

You can then readily use the `pvc` to mount to any resources in Kubernetes.

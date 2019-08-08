cluster-autoscaler
===================

Source Helm Chart: https://github.com/helm/charts/tree/master/stable/cluster-autoscaler

# Usage:

## Template out
This is mainly for debugging and development purposes to see what the output yaml
will look like before applying.

```
make ENVIRONMENT=dev-us template
```

## Install/Upgrade

```
make ENVIRONMENT=dev-us apply
```

## Delete

```
make ENVIRONMENT=dev-us delete
```

# AWS Keys

Either update the `./values.yaml` file with the AWS keys, or create a secret with
the keys for the cluster-autoscaler to use.

```
apiVersion: v1
data:
  AwsAccessKeyId: base64-encoded-string-here
  AwsSecretAccessKey: base64-encoded-string-here
kind: Secret
metadata:
  name: cluster-autoscaler-aws-cluster-autoscaler
  namespace: cluster-autoscaler
type: Opaque
```

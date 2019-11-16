cert-manager-cluster-issuer
==============================

This is an add on chart to the Helm Stable `cert-manager` chart.

You must have launch the `cert-manager` chart before you can use this chart.

This chart helps you create issuers.  

# Set AWS keys
Setting the keys for AWS.  Used for the DNS validation against route53

```
export AWS_ACCESS_KEY_ID="foo"
export AWS_SECRET_ACCESS_KEY="bar"
```

# Usage:

## Template

```
make ENVIRONMENT=dev-us template
```

## Apply

```
make ENVIRONMENT=dev-us apply
```

## delete

```
make ENVIRONMENT=dev-us delete
```

# Providers

## GCP Cloud DNS

Creating keys: https://docs.cert-manager.io/en/latest/tasks/issuers/setup-acme/dns01/google.html

# Creating certs:

## DNS01 verification:

Adding a request for a certificate via a dns01 verification

doc: https://docs.cert-manager.io/en/release-0.11/tutorials/acme/dns-validation.html

```
---
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: test1-dev-k8s-managedkube-com-tls
  namespace: default
spec:
  secretName: test1-dev-k8s-managedkube-com-tls
  issuerRef:
    # kind: ClusterIssuer
    name: issuer-dns01
  dnsNames:
  - test1.dev.k8s.managedkube.com
  - test2.dev.k8s.managedkube.com

```

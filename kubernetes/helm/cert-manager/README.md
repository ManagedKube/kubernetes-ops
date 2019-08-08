Kong:
========

Helm Hub: https://hub.helm.sh/charts/jetstack/cert-manager
Github: https://github.com/jetstack/cert-manager/tree/master/deploy/charts/cert-manager
Documentation: https://cert-manager.readthedocs.io



# Using with make file:
```
export KUBE_NAMESPACE=ingress
```

## apply:
```
make apply
```

## dependency-build

```
make dependency-build
```
## template
Default template outputs to: /tmp/helm-output.yaml
```
make template
```

## Deleting:
```
make delete
```

## Listing helm charts:
```
make list
```

# dns01 issuer
Doc: http://docs.cert-manager.io/en/latest/reference/issuers/acme/dns01.html

The `dns01` issuer is a method to authenticate to Let's Encrypt that you own the domain
by setting a DNS TXT record that is given back for the authorization.

This method is useful for internal load balancers where Let's Encrypt can not reach the
actual hostname's endpoint.  For this method to work, the `cert-manager` needs access
to where the domain is hosted.

## ingress definition
Using the `dns01` to retrieve certificates, a few annotations needs to be placed on
the ingress.  The following is an example:

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echoserver
  #namespace: echoserver
  annotations:
    kubernetes.io/tls-acme: "true"
    kubernetes.io/ingress.class: "nginx-internal"
    certmanager.k8s.io/cluster-issuer: issuer-dns01
    certmanager.k8s.io/acme-challenge-type: dns01
    certmanager.k8s.io/acme-dns01-provider: prod
spec:
  tls:
  - hosts:
    - gar.example.com
    secretName: foo-tls-secret
  rules:
  - host: gar.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: echoserver
          servicePort: 80
```

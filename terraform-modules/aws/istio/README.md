# Istio

## Why is there an Istio Terraform module?
The big reason is that Istio does NOT host their own helm repository that we can readily just use and that is
how we want to install Istio.  This means that we either setup our own helm repository with the Istio helm
chart or put it into here.  The decision for this module was to put the Istio Helm chart here.

## Release page:
https://github.com/istio/istio/releases/

## Extract the Istio release
Istio doesn't provide a helm registry and they provide the releases in a release package.  Download the release
you want to use, and extract it to this directory followed by the version number so the folder is 
in this pattern: `istio-<version>` to keep our folders consistent.

The package comes with a lot of files and you only need to check in the `istion-<version>/manifest` folder.

Remove folders from the extract (not needed)
* bin
* samples
* tools

## Install
General Helm install docs: https://istio.io/latest/docs/setup/install/helm/

Move to the Istio directory for the version you are setting up:
```
cd ./istio/istio-<VERSION>
```

Create the `istio-system` namespace:
```
kubectl create namespace istio-system
```

Install Istio base chart:
```
helm install istio-base -n istio-system manifests/charts/base
```

Some of these items we are adding in:
* nodeSelectors
* tolerations

Install Istio discovery:
```
helm install -n istio-system istiod manifests/charts/istio-control/istio-discovery
```

Install ingress gateway
```
helm install -n istio-system istio-ingress manifests/charts/gateways/istio-ingress
```

Install egress gateway
```
helm install -n istio-system istio-egress manifests/charts/gateways/istio-egress
```

## Enable auto Istio/Envoy injection

```
kubectl label namespace my-app istio-injection=enabled
```

## Verify mTLS
If you installed Istio with values.global.proxy.privileged=true, you can use tcpdump to verify traffic is encrypted or not.

```
$ kubectl exec -n foo "$(kubectl get pod -n foo -lapp=httpbin -ojsonpath={.items..metadata.name})" -c istio-proxy -- sudo tcpdump dst port 80  -A
```

## Istio networking
![alt text](/docs/images/istio-networking.png "Title")

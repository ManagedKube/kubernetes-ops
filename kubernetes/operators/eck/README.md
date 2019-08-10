ECK - Elastic Cloud on Kubernetes
================================

An operator to run Elasticsearch on Kubernetes


Source: https://github.com/elastic/cloud-on-k8s

Quick start guide: https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html

Example configs: https://github.com/elastic/cloud-on-k8s/tree/0.9/operators/config/samples

# Install


```
kubectl apply -f all-in-one.yaml
```

Work around for the timeout issue: https://github.com/elastic/cloud-on-k8s/issues/896#issuecomment-494346828
```
kubectl delete ValidatingWebhookConfiguration validating-webhook-configuration
```

```
kubectl apply -f elasticsearch-cluster.yaml
```


Get cluster info:
```
kubectl -n elasticsearch get elasticsearc
```

## Get Password

User: elastic

Get password:
```
kubectl -n elasticsearch get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode
```

## Port-forward to kibana

```
kubectl -n elasticsearch port-forward service/quickstart-kb-http 5601
```

In your browser, go to:  https://localhost:5601

# Not supporting nginx-ingress

It seems they don't want to support nginx ingress and have removed the ingress
resource example:  https://github.com/elastic/cloud-on-k8s/pull/806

Grafana Loki
===============

Source Helm Chart: https://github.com/grafana/loki/tree/master/production/helm


Get Grafana password:

```
kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Username: admin


Port forward to grafana:

```
kubectl port-forward --namespace loki service/loki-grafana 3000:80
```

Grafana Loki data source URL:

```
http://loki:3100/
```

# Searching in Grafana

https://github.com/grafana/loki/blob/master/docs/usage.md#searching-with-labels-and-distributed-grep

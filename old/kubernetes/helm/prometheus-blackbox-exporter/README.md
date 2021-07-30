Prometheus Blackbox Exporter
============================

Source project: https://github.com/prometheus/blackbox_exporter

Helm Chart: https://github.com/helm/charts/tree/master/stable/prometheus-blackbox-exporter

This tool helps us monitor URL endpoints and SSL certs.


# Usage:

## Setup
This installs the Prometheus Blackbox monitor into the Kubernetes cluster.

At this point, it is not monitoring anything


### Template

```
make template
```

### Install/update

```
make apply
```

### Delete

```
make delete
```

### Apply a monitor
This will apply the monitoring so that Prometheus will go and scrape the Blackbox
monitoring for items in the `servicemonitor`.

You will need to create a `servicemonitor` file for each environment and for the
items you want to monitor.

### Template

```
make EVIRONMENT=dev-us template
```

### Install/update

```
make EVIRONMENT=dev-us apply
```

### Delete

```
make EVIRONMENT=dev-us delete
```


# Testing
You can port forward to the Prometheus Blackbox Exporter pod and query
for a result via this URL

http://localhost:9115/probe?target=managedkube.com&module=http_2xx

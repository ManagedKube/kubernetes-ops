# helm chart - kube-prometheus-stack

Chart source: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

## AlertManager Receiver configuration
You can use the helm `values.yaml` file to configure the AlertManager's configs.  One problem with this
is that you have to commit the "receiver's" secret into git.  For example, like the Slack URL or the
Pager Duty's key.

An alternative way is to leave these receivers out of the helm `values.yaml` file and create the
AlertManager's CR (custom resource).

You can use the `../../kubernetes/menifest` module to apply arbitrary Kubernetes yamls to the cluster.

You can create the `AlertmanagerConfig` CR to send alerts to slack:
```
# This is the global alert config that prometheus is pointed to
# Doc: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/alerting.md#specify-global-alertmanager-config
#
# The reason why we are defining the prometheus global alert config setting is because, by default the kube-prometheus-stack operator
# sets the alert configs that are not global with a namespace selector on the "matcher" rules.  This means that you can not do a global
# alert config.  Their use case is that each namespace should set it's own alert configs.
#
# example: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/alerting.md#alertmanagerconfig-resource
# API doc: 
# * https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md
# * https://prometheus-operator.dev/docs/operator/api/#table-of-contents
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: global-alert-config
  namespace: monitoring
  labels:
    # This label has to match the `alertmanagerConfigSelector` config on what that is set to
    release: kube-prometheus-stack
spec:
  # doc: https://prometheus.io/docs/alerting/latest/configuration/#route
  route:
    groupBy: ['job', 'severity']
    groupWait: 30s
    groupInterval: 5m
    repeatInterval: 12h
    receiver: "null"
    routes:
    - receiver: "null"
      continue: false
      matchers:
      - matchType: "=~"
        name: alertname
        value: Watchdog|KubeControllerManagerDown|KubeProxyDown|KubeSchedulerDown
    - receiver: "null"
      continue: false
      matchers:
      - matchType: "=~"
        name: alertname
        value: TargetDown
      - matchType: "=~"
        name: job
        value: kube-proxy|kubelet
    - receiver: 'slack-${account_name}'
      continue: true
      matchers:
      - matchType: =~
        name: severity
        value: critical|warning
  receivers:
  - name: "null"
  # https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#slackconfig
  - name: 'slack-${account_name}'
    slackConfigs:
    - apiURL:
        # A kubernetes secret
        name: 'slack-key'
        key: 'key'
      sendResolved: true
      channel: ${channel_name}
      username: prom-${account_name}
      title: '{{ if ne .Status "firing" }}[{{ .Status | toUpper }}]{{ end }} {{ .CommonAnnotations.summary }}{{ .CommonAnnotations.message }}'
      titleLink: https://alertmanager.${domain_name}
      text: |-
          {{ range .Alerts }}
              Annotations:
              {{ range $key, $value := .Annotations }} - {{ $key }}: {{ $value }}
              {{ end }}
              Details:
              {{ range .Labels.SortedPairs }} - {{ .Name }} = {{ .Value }}
              {{ end }}
          {{ end }}

# # Example
# # Kubernetes Secret format
# ---
# apiVersion: v1
# kind: Secret
# type: Opaque
# metadata:
#   name: slack-key
#   namespace: monitoring
# data:
#   key: <base64 encoded Slack URL>
```

You can then place the secret into AWS Secrets and use the `../../external-secrets` module to 
sync the secret for this CR to use.  By going this route (which is way more work), you don't
have to commit the secret into git.

## How to test an alert
Once you have your alert config(s) in place, the following shows you, how you can send a test alert to the Alert Manager to see if it sends it off to your desired destination(s).

We are going to mimick how Prometheus sends an alert to the Alert Manager

Port forward to the Alert Manager:
```
kubectl -n monitoring port-forward svc/kube-prometheus-stack-alertmanager 9093
```



```
curl -si -X POST -H "Content-Type: application/json" "http://localhost:9093/api/v1/alerts" -d '
[
  {
    "labels": {
      "alertname": "TestAlert",
      "instance": "localhost:8080",
      "job": "node",
      "severity": "critical",
      "namespace": "foobar"
    },
    "annotations": {
      "summary": "Test alert"
    },
    "generatorURL": "http://localhost:9090/graph"
  }
]'
```

This will send an alert with the labels `severity=critical`.  Depending on what you want to trigger, you can adjust the items in the alert.

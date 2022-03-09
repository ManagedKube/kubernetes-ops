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
# example: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/alerting.md#alertmanagerconfig-resource
# API doc: 
# * https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md
# * https://prometheus-operator.dev/docs/operator/api/#table-of-contents
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: alert-config
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
    receiver: 'slack-${account_name}'
    matchers:
      ## Label to match.
    - name: severity
      ## Label value to match.
      value: critical
      ## Match type: !=, =, =~, !~
      ## Match operation available with AlertManager >= v0.22.0 and takes precedence over Regex (deprecated) if non-empty.
      # matchType: "="
      ## true | False - deprecated
      # regex: false
  receivers:
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

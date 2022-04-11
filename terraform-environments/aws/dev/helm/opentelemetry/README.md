# OpenTelemetry

Doc: https://opentelemetry.io/docs/

## Install sequence

1. opentelemetry-operator
2. opentelemetry-collector
3. grafana-tempo-server

## Data Path

1. App with OpenTelemetry SDK
2. App sends to an OpenTelemetry Collector
3. The OpenTelemetry Collector exporter sends to a Tempo server
4. Grafana adds the Tempo server as the datasource
5. User can query the Grafana frontend the traces

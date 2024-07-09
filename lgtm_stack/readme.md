#### LGTM Stack
```
Loki (Log Aggregation)
Grafana Dashboard (Telemetry Visualization)
Tempo (Trace Aggregation)
Mimir (Metrics Aggregation)
Loki, like Prometheus, but for logs.
Grafana, the open and composable observability and data visualization platform.
Tempo, a high volume, minimal dependency distributed tracing backend.
Mimir, the most scalable Prometheus backend.
grafana/mimir-distributed
grafana/loki-distributed
grafana/tempo-distributed
grafana/grafana
```



### 1. create k3s
```
k3d cluster create k3s-remote01

export KUBECONFIG="$(k3d kubeconfig write k3s-remote01)"

k3d cluster create k3s-central01
export KUBECONFIG="$(k3d kubeconfig write k3s-central01)"

```

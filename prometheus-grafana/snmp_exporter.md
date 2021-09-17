# snmp exporter

```
helm install prometheus prometheus-community/prometheus-snmp-exporter -n monitoring

helm upgrade --reuse-values -f prometheus-blackbox-exporter/values.yaml blackbox-exporter -n monitoring prometheus-community/prometheus-blackbox-exporter

helm upgrade --reuse-values -f kube-prometheus-stack/values.yaml prometheus -n monitoring prometheus-community/kube-prometheus-stack
```

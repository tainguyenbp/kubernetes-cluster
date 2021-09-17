# snmp exporter

```
helm install snmp prometheus-community/prometheus-snmp-exporter -n monitoring

helm upgrade --reuse-values -f prometheus-snmp-exporter/values.yaml snmp -n monitoring prometheus-community/prometheus-snmp-exporter

```

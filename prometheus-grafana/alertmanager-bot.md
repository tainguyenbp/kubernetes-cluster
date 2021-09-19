# alertmanager bot telegram
```

helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update

helm install alertmanager-bot k8s-at-home/alertmanager-bot -n monitoring


helm uninstall alertmanager-bot -n monitoring


helm upgrade --reuse-values -f ./values.yaml alertmanager-bot -n monitoring k8s-at-home/alertmanager-bot




```

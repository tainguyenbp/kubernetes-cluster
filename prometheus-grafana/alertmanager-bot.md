# alertmanager bot telegram
```

helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update

helm install alertmanager-bot k8s-at-home/alertmanager-bot -n monitoring


helm uninstall alertmanager-bot -n monitoring


helm upgrade --reuse-values -f ./values.yaml alertmanager-bot -n monitoring k8s-at-home/alertmanager-bot


helm install alertmanager-bot ./alertmanager-bot-0.1.0.tgz -n monitoring

helm list

helm3 del <release-name> --namespace <namespace>

# list and delete the release
helm3 del -n rook-ceph $(helm3 ls -n rook-ceph | grep 'rook-ceph' | awk '{print $1}')

```

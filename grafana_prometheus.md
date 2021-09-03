### Prometheus & Grafana
### Kubernetes (k8s) helm builds Prometheus + Grafana monitoring 1

### Step 1. Install helm version 3 on k8s master01
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Step 1. Install helm version 3 on k8s master01
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Kubernetes (k8s) helm builds Prometheus + Grafana monitoring 2
### Step 1. Install helm version 3 on k8s master01
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Step 2. Helm to install prometheus-operator
```
helm install stable/prometheus-operator --generate-name
```

### Step 3. Helm to install prometheus-operator
```
helm install stable/prometheus-operator --generate-name
```

### Step 4. Let’s edit the Service of Prometheus and add IP cluster the type to ClusterIP. Note that your Service name is differ from mine.
```
kubectl edit svc prometheus-grafana -n monitoring
```


### Step 8. Let’s edit the Service of Grafana and add IP cluster the type to ClusterIP. Note that your Service name is differ from mine.
```
kubectl edit svc prometheus-grafana -n monitoring
```
### Kubernetes (k8s) helm builds Prometheus + Grafana monitoring 3

Install NFS and rpcbind service
```

mkdir -p /data/NFS

yum -y install nfs-utils rpcbind

echo "/data/NFS *(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports

systemctl start nfs && systemctl start rpcbind

systemctl enable nfs-server && systemctl enable rpcbind

Install nfs on cluster nodes

yum -y install nfs-utils

kubectl create ns monitoring

helm pull stable/prometheus --version 11.0.1

tar xvf prometheus-*.tgz

cat > prometheus/templates/prometheus-pv.yaml << EOF
---
{{- if .Values.server.persistentVolume.enabled -}}
# server pv
apiVersion: v1
kind: PersistentVolume
metadata:
    name: {{ .Values.server.persistentVolume.storageClass }}
spec:
    capacity:
      storage: {{ .Values.server.persistentVolume.size }}
    accessModes:
      - ReadWriteOnce
    volumeMode: Filesystem
    persistentVolumeReclaimPolicy: Retain
    storageClassName: {{ .Values.server.persistentVolume.storageClass }}
    nfs:
      path: {{ .Values.nfs.PrometheusPath }}
      server: {{ .Values.nfs.server }}
{{ end }}
---
# serpushgatewayver pv
{{- if .Values.pushgateway.persistentVolume.enabled -}}
apiVersion: v1
kind: PersistentVolume
metadata:
    name: {{ .Values.pushgateway.persistentVolume.storageClass }}
spec:
    capacity:
      storage: {{ .Values.pushgateway.persistentVolume.size }}
    accessModes:
      - ReadWriteOnce
    volumeMode: Filesystem
    persistentVolumeReclaimPolicy: Retain
    storageClassName: {{ .Values.pushgateway.persistentVolume.storageClass }}
    nfs:
      path: {{ .Values.nfs.PushgatewayPath }}
      server: {{ .Values.nfs.server }}
{{ end }}
---
{{- if .Values.alertmanager.persistentVolume.enabled -}}
# alertmanager pv
apiVersion: v1
kind: PersistentVolume
metadata:
    name: {{ .Values.alertmanager.persistentVolume.storageClass }}
spec:
    capacity:
      storage: {{ .Values.alertmanager.persistentVolume.size }}
    accessModes:
      - ReadWriteOnce
    volumeMode: Filesystem
    persistentVolumeReclaimPolicy: Retain
    storageClassName: {{ .Values.alertmanager.persistentVolume.storageClass }}
    nfs:
      path: {{ .Values.nfs.PlertmanagerPath }}
      server: {{ .Values.nfs.server }}
{{ end }}
EOF



chmod 775 -R /data/NFS/monitoring
chown nobody:nogroup -R /data/NFS/monitoring

cat > prometheus.yaml << EOF
# Prometheus
server:
  replicaCount: 2
  persistentVolume:
    enabled: false
    size: 10Gi
    storageClass: monitoring-prometheus-nfs
    accessModes:
      - ReadWriteOnce
# pushgateway 
pushgateway:
  replicaCount: 2
  persistentVolume:
    enabled: false
    size: 2Gi
    storageClass: monitoring-pushgateway-nfs
    accessModes:
      - ReadWriteOnce
# alertmanager
alertmanager:
  replicaCount: 2
  persistentVolume:
    enabled: false
    size: 2Gi
    storageClass: monitoring-alertmanager-nfs
    accessModes:
      - ReadWriteOnce
# nodeExporter
nodeExporter:
  tolerations:
  - operator: Exists

# Prometheus 
serverFiles:
  alerting_rules.yml:
    groups:
    - name: alert.rule
      rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: warning
        annotations:
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minutes."
# alertmanager 
alertmanagerFiles:
  alertmanager.yml:
    global:
      smtp_smarthost: 'smtp.gmail.com:465'
      smtp_from: 'gmail.com'
      smtp_auth_username: 'gmail.com'
      smtp_auth_password: 'password'
      smtp_require_tls: false
    route:
      group_by: ['alertname']
      group_wait: 10s
      group_interval: 10s
      repeat_interval: 10m
      receiver: nntain-monitoring
    receivers:
    - name: 'live-monitoring'
      email_configs:
      - to: 'gmail.com'
nfs:
  PrometheusPath: /monitoring/prometheus
  PushgatewayPath: /monitoring/pushgateway
  PlertmanagerPath: /monitoring/alertmanager
  server: 10.10.2.225
EOF

helm install prometheus -n monitoring --values prometheus.yaml prometheus/

kubectl get pvc -n monitoring

kubectl get pod -n monitoring -w

kubectl get svc -n monitoring

kubectl -n monitoring port-forward svc/prometheus-server 80 --address 10.10.2.225

kubectl -n monitoring port-forward svc/prometheus-node-exporter 9100 --address 10.10.2.225

kubectl edit svc -n monitoring prometheus-server

kubectl get svc -n monitoring

```

# Issue fix 
### Issue fix 1
```
access node01 or node02 or node03
cd /etc/cni/net.d

remove config network calico
rm -rf 10-calico.conflist calico-kubeconfig

```


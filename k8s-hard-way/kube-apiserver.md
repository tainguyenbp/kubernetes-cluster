# kubernetes the hard way ubuntu 
### Kube API Server - API Server
### Requirement step
### Generate from ssl from server master01 - 192.168.1.2
```
mkdir -p /home/tainguyenbp/ssl-k8s/
cd /home/tainguyenbp/ssl-k8s/

cat > openssl-kube-apiserver.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 192.128.1.2
IP.3 = 192.128.1.3
IP.4 = 192.128.1.4
IP.8 = 127.0.0.1
EOF
```
```
openssl genrsa -out kube-apiserver.key 2048
openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl-kube-apiserver.cnf
openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-apiserver.crt -extensions v3_req -extfile openssl-kube-apiserver.cnf -days 1000
```

```
  kubectl config set-cluster k8s-tainguyenbp-local \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig


 kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.crt \
    --client-key=kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=k8s-tainguyenbp-local \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
```

```
copy ca.crt genareted from server master01 to server master01, etcd02, etcd03
copy etcd-server.crt, etcd-server.key from server master01 to server etcd01, etcd02, etcd03
```

### Install Kube API Server on server Master01 - 192.168.1.2
```
ETCD_VER=v3.5.0

GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
/tmp/etcd-download-test/etcdutl version

sudo mv /tmp/etcd-download-test/etcd /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdctl /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdutl /usr/local/bin/
```

```


cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
 --advertise-address=192.168.1.2 \\
 --allow-privileged=true \\
 --apiserver-count=3 \\
 --audit-log-maxage=30 \\
 --audit-log-maxbackup=3 \\
 --audit-log-maxsize=100 \\
 --audit-log-path=/var/log/audit.log \\
 --authorization-mode=Node,RBAC \\
 --bind-address=0.0.0.0 \\
 --client-ca-file=/var/lib/kubernetes/ca.crt \\
 --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
 --enable-bootstrap-token-auth=true \\
 --etcd-cafile=/var/lib/kubernetes/ca.crt \\
 --etcd-certfile=/var/lib/kubernetes/etcd-server.crt \\
 --etcd-keyfile=/var/lib/kubernetes/etcd-server.key \\
 --etcd-servers=https://192.168.1.9:2379,https://192.168.1.10:2379,https://192.168.1.11:2379 \\
 --event-ttl=1h \\
 --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
 --kubelet-certificate-authority=/var/lib/kubernetes/ca.crt \\
 --kubelet-client-certificate=/var/lib/kubernetes/kube-apiserver.crt \\
 --kubelet-client-key=/var/lib/kubernetes/kube-apiserver.key \\
 --kubelet-https=true \\
 --runtime-config='api/all=true' \\
 --service-account-key-file=/var/lib/kubernetes/service-account.crt \\
 --service-account-signing-key-file=/var/lib/kubernetes/service-account.key \\
 --service-account-issuer=api \\
 --service-cluster-ip-range=10.96.0.0/24 \\
 --service-node-port-range=30000-32767 \\
 --tls-cert-file=/var/lib/kubernetes/kube-apiserver.crt \\
 --tls-private-key-file=/var/lib/kubernetes/kube-apiserver.key \\
 --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

```
```
kubectl get componentstatuses --kubeconfig /var/lib/kubernetes/admin.kubeconfig 
```

### Install Kube API Server on server Master02 - 192.168.1.3
```
ETCD_VER=v3.5.0

GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
/tmp/etcd-download-test/etcdutl version

sudo mv /tmp/etcd-download-test/etcd /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdctl /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdutl /usr/local/bin/
```

```


cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
 --advertise-address=192.168.1.3 \\
 --allow-privileged=true \\
 --apiserver-count=3 \\
 --audit-log-maxage=30 \\
 --audit-log-maxbackup=3 \\
 --audit-log-maxsize=100 \\
 --audit-log-path=/var/log/audit.log \\
 --authorization-mode=Node,RBAC \\
 --bind-address=0.0.0.0 \\
 --client-ca-file=/var/lib/kubernetes/ca.crt \\
 --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
 --enable-bootstrap-token-auth=true \\
 --etcd-cafile=/var/lib/kubernetes/ca.crt \\
 --etcd-certfile=/var/lib/kubernetes/etcd-server.crt \\
 --etcd-keyfile=/var/lib/kubernetes/etcd-server.key \\
 --etcd-servers=https://192.168.1.9:2379,https://192.168.1.10:2379,https://192.168.1.11:2379 \\
 --event-ttl=1h \\
 --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
 --kubelet-certificate-authority=/var/lib/kubernetes/ca.crt \\
 --kubelet-client-certificate=/var/lib/kubernetes/kube-apiserver.crt \\
 --kubelet-client-key=/var/lib/kubernetes/kube-apiserver.key \\
 --kubelet-https=true \\
 --runtime-config='api/all=true' \\
 --service-account-key-file=/var/lib/kubernetes/service-account.crt \\
 --service-account-signing-key-file=/var/lib/kubernetes/service-account.key \\
 --service-account-issuer=api \\
 --service-cluster-ip-range=10.96.0.0/24 \\
 --service-node-port-range=30000-32767 \\
 --tls-cert-file=/var/lib/kubernetes/kube-apiserver.crt \\
 --tls-private-key-file=/var/lib/kubernetes/kube-apiserver.key \\
 --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

```
```
kubectl get componentstatuses --kubeconfig /var/lib/kubernetes/admin.kubeconfig 
```

### Install Kube API Server on server Master03 - 192.168.1.4
```
ETCD_VER=v3.5.0

GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
/tmp/etcd-download-test/etcdutl version

sudo mv /tmp/etcd-download-test/etcd /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdctl /usr/local/bin/
sudo mv /tmp/etcd-download-test/etcdutl /usr/local/bin/
```

```


cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
 --advertise-address=192.168.1.4 \\
 --allow-privileged=true \\
 --apiserver-count=3 \\
 --audit-log-maxage=30 \\
 --audit-log-maxbackup=3 \\
 --audit-log-maxsize=100 \\
 --audit-log-path=/var/log/audit.log \\
 --authorization-mode=Node,RBAC \\
 --bind-address=0.0.0.0 \\
 --client-ca-file=/var/lib/kubernetes/ca.crt \\
 --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
 --enable-bootstrap-token-auth=true \\
 --etcd-cafile=/var/lib/kubernetes/ca.crt \\
 --etcd-certfile=/var/lib/kubernetes/etcd-server.crt \\
 --etcd-keyfile=/var/lib/kubernetes/etcd-server.key \\
 --etcd-servers=https://192.168.1.9:2379,https://192.168.1.10:2379,https://192.168.1.11:2379 \\
 --event-ttl=1h \\
 --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
 --kubelet-certificate-authority=/var/lib/kubernetes/ca.crt \\
 --kubelet-client-certificate=/var/lib/kubernetes/kube-apiserver.crt \\
 --kubelet-client-key=/var/lib/kubernetes/kube-apiserver.key \\
 --kubelet-https=true \\
 --runtime-config='api/all=true' \\
 --service-account-key-file=/var/lib/kubernetes/service-account.crt \\
 --service-account-signing-key-file=/var/lib/kubernetes/service-account.key \\
 --service-account-issuer=api \\
 --service-cluster-ip-range=10.96.0.0/24 \\
 --service-node-port-range=30000-32767 \\
 --tls-cert-file=/var/lib/kubernetes/kube-apiserver.crt \\
 --tls-private-key-file=/var/lib/kubernetes/kube-apiserver.key \\
 --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

```
```
kubectl get componentstatuses --kubeconfig /var/lib/kubernetes/admin.kubeconfig 
```

### Link reference
```
https://github.com/kelseyhightower/kubernetes-the-hard-way/issues/626
https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
```

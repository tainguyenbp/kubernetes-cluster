### Intall package requirement and docker:
```
#!/bin/bash

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y && yum install docker-ce-18.06.2.ce -y
usermod -aG docker $(whoami)
```
### Setup daemon docker.
```
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
```
### start Docker
```
systemctl enable docker.service
systemctl daemon-reload
systemctl start docker
```

### turn off SELinux
```
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
```

### turn off Firewall
```
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld
```

### sysctl
```
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1
```

### turn off swap
```
sed -i '/swap/d' /etc/fstab
swapoff -a
```

### Add yum repo file for Kubernetes
```
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```
### Install Kubernetes
```
yum install -y -q kubeadm kubelet kubectl
```
### Start Kubernetes
```
systemctl enable kubelet
systemctl start kubelet
```



### Add infor on all master và worker: /etc/hosts
```
192.168.1.10	k8s-master-01.tainn.local
192.168.1.15	k8s-worker-01.tainn.local
192.168.1.20	k8s-worker-02.tainn.local
```
### On k8s-master-01.tainn.local: Create Cluster
```
parameters: --pod-network-cidr is network subnet of pods -> I use network subnet --pod-network-cidr=172.16.0.0/16

[root@k8s-master-01.tainn.local ~]# kubeadm init --apiserver-advertise-address=192.168.1.10 --pod-network-cidr=172.16.0.0/16
........
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.10:6443 --token plgsow.t93efti1mkfigi9t \
    --discovery-token-ca-cert-hash sha256:2357d1be0a1471f5f1f1e11761f61c3d682630d21b3214591485a9fdcdc7b533


[root@k8s-master-01.tainn.local ~]# mkdir -p $HOME/.kube
[root@k8s-master-01.tainn.local ~]# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[root@k8s-master-01.tainn.local ~]# sudo chown $(id -u):$(id -g) $HOME/.kube/config

[root@k8s-master-01.tainn.local ~]# curl https://docs.projectcalico.org/manifests/calico.yaml -O
[root@k8s-master-01.tainn.local ~]# kubectl apply -f calico.yaml
```

### Check status  Kubernetes cluster:
```
[root@k8s-master-01.tainn.local ~]# kubectl cluster-info
Kubernetes master is running at https://192.168.1.10:6443
KubeDNS is running at https://192.168.1.10:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[root@k8s-master-01 ~]# kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
k8s-master-01.tainn.local   Ready    master   17m   v1.18.6
[root@k8s-master-01 ~]# kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-578894d4cd-lsvph   1/1     Running   0          4m33s
kube-system   calico-node-jpqxx                          1/1     Running   0          4m33s
kube-system   coredns-66bff467f8-7l5f9                   1/1     Running   0          19m
kube-system   coredns-66bff467f8-sk9sp                   1/1     Running   0          19m
kube-system   etcd-k8s-master-01.tainn.local                        1/1     Running   0          20m
kube-system   kube-apiserver-k8s-master-01.tainn.local              1/1     Running   0          20m
kube-system   kube-controller-manager-k8s-master-01.tainn.local     1/1     Running   0          20m
kube-system   kube-proxy-x479t                           1/1     Running   0          19m
kube-system   kube-scheduler-k8s-master-01.tainn.local              1/1     Running   0          20m
```

### Join node to Cluster: excute commnad on cluster get get token join
```
[root@k8s-master-01.tainn.local ~]# kubeadm token create --print-join-command
W0808 21:45:17.466412   33225 configset.go:202] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
kubeadm join 192.168.1.10:6443 --token 9pmzz9.vqew8c5cahueky0v     --discovery-token-ca-cert-hash sha256:2357d1be0a1471f5f1f1e11761f61c3d682630d21b3214591485a9fdcdc7b533
```
### Join Worker to cluster
```
- Thực hiện kết nối Node vào Cluster với token ở trên:
[root@k8s-worker-01.tainn.local ~]# kubeadm join 192.168.1.10:6443 --token 9pmzz9.vqew8c5cahueky0v     --discovery-token-ca-cert-hash sha256:2357d1be0a1471f5f1f1e11761f61c3d682630d21b3214591485a9fdcdc7b533
W0808 21:48:28.532949   12783 join.go:346] [preflight] WARNING: JoinControlPane.controlPlane settings will be ignored when control-plane flag is not set.
[preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.18" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
### check status node on k8s-master-01.tainn.local:
```
[root@k8s-master-01.tainn.local  ~]# kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
k8s-master-01.tainn.local   Ready    master   27m   v1.18.6
k8s-worker-01.tainn.local    Ready    <none>   87s   v1.18.6
k8s-worker-02.tainn.local    Ready    <none>   82s   v1.18.6
````
### Check infor 1 node in the k8s cluster:
```
[root@k8s-master-01 ~]# kubectl describe node/k8s-worker-01.tainn.local
```

### Config kubectl client access to Cluster:
```
[root@client ~]# kubectl config view
apiVersion: v1
clusters: null
contexts: null
current-context: ""
kind: Config
preferences: {}
users: null

[root@tainn-kubeadm ~]# scp root@192.168.1.10:/etc/kubernetes/admin.conf ~/.kube/config-mycluster
root@192.168.1.10's password:
admin.conf                                                                                                                            100% 5454     4.9MB/s   00:00

[root@tainn-kubeadm ~]# export KUBECONFIG=/root/.kube/config-mycluster
[root@tainn-kubeadm ~]# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.1.10:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

[root@tainn ~]# kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
k8s-master-01.tainn.local    Ready    master   42m   v1.18.6
k8s-worker-01.tainn.local   Ready    <none>   16m   v1.18.6
k8s-worker-02.tainn.local   Ready    <none>   16m   v1.18.6

[root@tainn-kubeadm .kube]# kubectl config get-contexts
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
*         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin
[root@tainn-kubeadm .kube]#


### config for admin k8s with multi cluster, example I have the Kube Cluster config file  ~/.kube/config:
export KUBECONFIG=~/.kube/config:~/.kube/config-mycluster
kubectl config view --flatten > ~/.kube/config_temp
mv ~/.kube/config_temp ~/.kube/config
kubectl config get-contexts
```

### symboy * is current context, if you want to change to context kubernetes-admin@kubernetes then you can run comand:
```
kubectl config use-context kubernetes-admin@kubernetes
```
### noted workload:
```
1. Pod: one pod, one process, one container, context (namespace and cgroups)

2. Deployment: trên đơn vị pod thì có deployment, để quản lý pod và replicaset, tính năng rollback, rollout.

3. Statefullset: quản lý pod, đảm bảo pod persit vs nhau về tài nguyên network, store

4. DaemonSet: mục đích để chạy và trải đều pod lên các node, thường logging sẽ chạy

5. Job: Tạo 1 crontab vào images, pod, container khi chạy xong sẽ terminiting

6. CronJob: định kỳ 1 tuần chạy 1 lần, nếu failed 3 lần thì sẽ termnating

7. Network 2 component:
- Service: cung cấp cách thức expose layer4 của pod, giúp user và service bên ngoài access vào resouce con pod chạy trên kubernetes, service loadbalance cho toàn bộ pods bên trong nó

- Ingress: cách k8s expose connect user có thể truy cập thông qua layer7 HTTP/HTTPS

8. Stogress:
8.1 Volume: sẽ đi cùng với sự sống của pod, nếu pod sống thì volume sống, pod chết thì toàn bộ data trong volume chết

8.2 PV - PersistentVolume: Volume sẽ dc gán vào pods và khi pods chết sẽ k mất, có thể sử dụng external storage: CEPH, Minio, NFS...

8.3 PCV - PersistentVolumeClaim:  

```

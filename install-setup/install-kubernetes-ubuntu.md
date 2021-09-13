### Install kubernetes ubuntu
```
curl -fssl https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list deb https://apt.kubernetes.io/ kubernetes-xenial main EOF

sudo swapoff -a 

sudo apt-get update
sudo swapoff -a 

sudo apt-get update

sudo apt-get install docker-ce -y

# [WARNING SystemVerification]: this Docker version is not on the list of validated versions: 20.10.8. Latest validated version: 19.03
sudo apt-get install docker-ce=5:19.03.12~3-0~ubuntu-focal -y

sudo apt-get install docker-ce=5:20.10.8~3-0~ubuntu-focal

sudo apt-get install containerd.io -y

sudo apt-get install -y kubelet=1.19.7-00 kubeadm=1.19.7-00 kubectl=1.19.7-00

sudo apt-get install -y kubelet=1.19.14-00 kubeadm=1.19.14-00 kubectl=1.19.14-00

sudo apt-get install kubelet=1.20.5-00 kubeadm=1.20.5-00 kubectl=1.20.5-00 -y

sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


Update the apt package index and install packages needed to use the Kubernetes apt repository:

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl


**Download the Google Cloud public signing key:**

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

**Add the Kubernetes apt repository:**

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update && sudo apt-get install curl apt-transport-https ca-certificates curl software-properties-common -y 
curl -fssl https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF




```


Change CgroupDriver of docker to systemd
```
sudo more /etc/docker/daemon.json

sudo docker info -f {{.CgroupDriver}}
sudo nano /etc/docker/daemon.json

{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
sudo service docker restart
sudo service docker status

```
Docker version
```
kubeadm@master01:~$ docker --version
Docker version 20.10.8, build 3967b7d
```

Stacked control plane and etcd nodes
```


sudo kubeadm init --control-plane-endpoint "192.1268.1.1:6443" --upload-certs --v=15
sudo kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs


sudo kubeadm init --control-plane-endpoint "192.1268.1.1:6443" --pod-network-cidr=192.168.0.0/16 --upload-certs --v=15

sudo kubeadm init --control-plane-endpoint "192.1268.1.1:6443" --pod-network-cidr=10.15.0.0/16 --upload-certs --v=15

kubeadm init --apiserver-advertise-address="192.1268.1.1" --apiserver-cert-extra-sans="192.1268.1.1" --node-name k8s-master --pod-network-cidr=10.15.0.0/16

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


mkdir -p $HOME/.kube   
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config   
chown $(id -u):$(id -g) $HOME/.kube/config
```
### create token join master 1
```
kubeadm init phase upload-certs --upload-certs

kubeadm token create \
--print-join-command \
--certificate-key \
$(kubeadm certs certificate-key)

sudo kubeadm token create --print-join-command --certificate-key `sudo kubeadm init phase upload-certs --upload-certs | sed -n '3 p'`
```

### create token join worker 1
```
kubeadm token create --print-join-command
```

### Certificate Management with kubeadm
```
kubeadm alpha certs check-expiration
```

### Check list token with kubeadm
```
kubeadm token lists
```
### script check 
```
kubectl get pods -n production | grep CrashLoopBackOff | awk '{print $1}' | xargs kubectl describe pod -n production  | grep event

kubectl get pods -n production | grep Pending | awk '{print $1}' | xargs kubectl delete pod -n production  --force
```
# Issue fix 
### Issue fix 1
```
root@master01:/home/sysadmin/monitoring/kubernetes# kubectl get cs
NAME                 STATUS      MESSAGE                                                                                       ERROR
controller-manager   Unhealthy   Get "http://127.0.0.1:10252/healthz": dial tcp 127.0.0.1:10252: connect: connection refused
scheduler            Unhealthy   Get "http://127.0.0.1:10251/healthz": dial tcp 127.0.0.1:10251: connect: connection refused
etcd-0               Healthy     {"health":"true"}
```
vim /etc/kubernetes/manifests/kube-scheduler.yaml file and comment line 19  "- --port=0"
```
  1 apiVersion: v1
  2 kind: Pod
  3 metadata:
  4   creationTimestamp: null
  5   labels:
  6     component: kube-scheduler
  7     tier: control-plane
  8   name: kube-scheduler
  9   namespace: kube-system
 10 spec:
 11   containers:
 12   - command:
 13     - kube-scheduler
 14     - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
 15     - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
 16     - --bind-address=127.0.0.1
 17     - --kubeconfig=/etc/kubernetes/scheduler.conf
 18     - --leader-elect=true
 19       #    - --port=0
 20     image: k8s.gcr.io/kube-scheduler:v1.19.14
```

vim /etc/kubernetes/manifests/kube-controller-manager.yaml file and comment line 27  "- --port=0"
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    component: kube-controller-manager
    tier: control-plane
  name: kube-controller-manager
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-controller-manager
    - --allocate-node-cidrs=true
    - --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
    - --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
    - --bind-address=127.0.0.1
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --cluster-cidr=10.11.0.0/16
    - --cluster-name=kubernetes
    - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
    - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
    - --controllers=*,bootstrapsigner,tokencleaner
    - --kubeconfig=/etc/kubernetes/controller-manager.conf
    - --leader-elect=true
    - --node-cidr-mask-size=24
      #    - --port=0
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
    - --root-ca-file=/etc/kubernetes/pki/ca.crt
```
restart kubelet on three machines and check cs
```
systemctl restart kubelet.service

root@master01:/home/sysadmin/monitoring/kubernetes# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health":"true"}
```


# Note 1
```
sudo kubeadm reset --cri-socket unix:///var/run/crio/crio.sock
sudo kubeadm reset -f

sudo rm -rf /etc/cni/net.d/*
sudo rm -rf .kube/
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/etcd
sudo rm -rf /etc/kubernetes/ 
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/etcd
sudo rm -rf /etc/cni/net.d
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F 
sudo iptables -X
sudo iptables -t filter -F 
sudo iptables -t filter -X
sudo ipvsadm --clear
sudo rm -rf /etc/kubernetes
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*

sudo kubeadm reset -f
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
sudo iptables -F && sudo iptables -X
sudo iptables -t nat -F && sudo iptables -t nat -X
sudo iptables -t raw -F && sudo iptables -t raw -X
sudo iptables -t mangle -F && sudo iptables -t mangle -X
sudo systemctl restart docker

sudo kubeadm reset
sudo rm -rf .kube/ && sudo rm -rf /etc/kubernetes/ && sudo rm -rf /var/lib/kubelet/ && sudo rm -rf /var/lib/etcd && sudo rm -rf /etc/cni/net.d

```
# Note 2
```

kubectl drain master03 --delete-local-data --force --ignore-daemonsets
kubectl delete node master03 
kubectl drain master02 --delete-local-data --force --ignore-daemonsets
kubectl delete node master02

```

# Note 3
```
sudo apt-get remove docker-ce kubelet kubeadm kubectl -
sudo apt-get purge docker-ce kubeadm kubectl kubelet kubernetes-cni kube* 
sudo apt autoremove
sudo apt-get remove docker-ce container.io
sudo apt-get purge docker-ce container.io
sudo apt autoremove


```
# Note 4
```

Use following two commands to remove calico from your node:

kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl delete -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml


To undeploy calico, we have to do the usual kubectl delete -f <yaml>, and then delete a calico conf file in each of the nodes /etc/cni/net.d/. This configuration file along with other binaries are loaded on to the host by the init container.
````














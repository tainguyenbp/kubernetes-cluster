### Install kubernetes ubuntu
```
curl -fssl https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list deb https://apt.kubernetes.io/ kubernetes-xenial main EOF

sudo swapoff -a 

sudo apt-get update
sudo apt-get install docker-ce kubelet=1.20.5-00 kubeadm=1.20.5-00 kubectl=1.20.5-00 -y


sudo kubeadm init --control-plane-endpoint 192.168.1.1:6443 --upload-certs --v=15

sudo apt-get install -y kubelet=1.19.7-00 kubeadm=1.19.7-00 kubectl=1.19.7-00


sudo apt-get install -y kubelet=1.19.14-00 kubeadm=1.19.14-00 kubectl=1.19.14-00
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


sudo swapoff -a 

sudo apt-get update

sudo apt-get install docker-ce=5:20.10.8~3-0~ubuntu-focal containerd.io -y

sudo apt-get install kubelet=1.20.5-00 kubeadm=1.20.5-00 kubectl=1.20.5-00 -y

sudo apt-mark hold kubelet kubeadm kubectl

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

```
# Note 1
```
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
```
# Note 2
```
sudo kubeadm reset -f
sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
sudo iptables -F && sudo iptables -X
sudo iptables -t nat -F && sudo iptables -t nat -X
sudo iptables -t raw -F && sudo iptables -t raw -X
sudo iptables -t mangle -F && sudo iptables -t mangle -X
sudo systemctl restart docker
```

# Note 3
```
sudo apt-get remove docker-ce kubelet kubeadm kubectl -y
sudo apt-get purge docker-ce kubeadm kubectl kubelet kubernetes-cni kube* 
sudo apt autoremove
```
















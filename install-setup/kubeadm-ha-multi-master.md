# Set up a Highly Available Kubernetes Cluster using kubeadm

```
sudo kubeadm init --control-plane-endpoint "192.1268.1.1:6443" --pod-network-cidr=10.50.0.0/16 --upload-certs --v=15
kubeadm init --control-plane-endpoint="92.1268.1.1:6443" --upload-certs --apiserver-advertise-address=92.1268.1.2 --pod-network-cidr=10.50.0.0/16 --v=15
```

```
  apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update && apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io docker-ce-cli=5:19.03.10~3-0~ubuntu-focal
  
  apt update && apt install -y kubelet=1.19.14-00 kubeadm=1.19.14-00 kubectl=1.19.14-00
```

```
dpkg -l | grep -i docker
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
```


```


apt-cache madison docker-ce
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
``

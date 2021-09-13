# Set up a Highly Available Kubernetes Cluster using kubeadm

```
sudo kubeadm init --control-plane-endpoint "192.1268.1.1:6443" --pod-network-cidr=10.50.0.0/16 --upload-certs --v=15
kubeadm init --control-plane-endpoint="92.1268.1.1:6443" --upload-certs --apiserver-advertise-address=92.1268.1.2 --pod-network-cidr=10.50.0.0/16 --v=15
```

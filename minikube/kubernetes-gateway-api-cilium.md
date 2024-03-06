Kubernetes Gateway API

minikube start --driver=none --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost

minikube start --network-plugin=cni --cni=false

minikube start --network-plugin=cni  --cpus=4 --memory=6144 --kubernetes-version=v1.27 --pod-network-cidr=10.244.0.0/16


minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.22.2

minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.27

minikube start --driver=docker --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.27

minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost

minikube stop



minikube delete -p minikube

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v0.7.0/standard-install.yaml

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/webhook-install.yaml



helm install cilium cilium/cilium --version 1.14.6 \
    --namespace kube-system \
    --set kubeProxyReplacement=true \
    --set gatewayAPI.enabled=true

helm install cilium cilium/cilium --version 1.15.1 \
    --namespace kube-system \
    --set kubeProxyReplacement=true \
    --set gatewayAPI.enabled=true

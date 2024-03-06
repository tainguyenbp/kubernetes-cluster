Kubernetes Gateway API

minikube start --driver=none --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost

minikube start --network-plugin=cni --cni=false

minikube start --network-plugin=cni  --cpus=4 --memory=6144


minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.22.2

minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.27

minikube start --driver=docker --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost --kubernetes-version=v1.27

minikube start --network-plugin=cni --cni=false --apiserver-ips 127.0.0.1 --apiserver-name localhost

minikube stop

minikube delete -p minikube

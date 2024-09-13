# This Repository contains the yaml files used for creation of ScyllaDB cluster on GKE using Helm Charts.
```
eksctl create cluster -f cluster-config.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.crds.yaml

helm upgrade --install cert-manager jetstack/cert-manager \
 --namespace cert-manager \
 --create-namespace \
 --version v1.15.3 \
 --set installCRDs=true


```

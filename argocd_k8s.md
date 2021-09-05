# Deploy ArgoCD Non-HA deploy on k8s
### create namespace 
```
kubectl create namespace argocd
```
### apply config namespace 
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.3/manifests/install.yaml
```
### get user pass
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo ""
```
### edit to nodeport
```
kubectl -n argocd edit  service/argocd-server
```
### command port-forward access UI
```
kubectl -n argocd port-forward deployment.apps/argocd-server 8080:8080
```
### create namespace 
```
kubectl create namespace argocd
```
### create namespace 
```
kubectl create namespace argocd
```

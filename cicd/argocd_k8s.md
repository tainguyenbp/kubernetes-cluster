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
kubectl -n argocd port-forward deployment.apps/argocd-server 8080:8080 --address 0.0.0.0
```
### get pods on namespace argocd
```
kubectl get pods -n argocd
```
### get statefulsets 
```
kubectl get statefulsets -A
kubectl get sts -A
```
### delete statefulsets 
```
kubectl get statefulsets -A
kubectl get sts -A

kubectl delete sts argocd-redis-ha-server argocd-application-controller -n argocd

kubectl delete sts argocd-redis-ha-server -n argocd

kubectl delete sts argocd-application-controller -n argocd
```

# Deploy ArgoCD Non-HA deploy on k8s
### create namespace 
```
kubectl create namespace argocd
```
### apply config namespace 
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.3/manifests/ha/install.yaml
```
### get user pass
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo ""
```
### edit to nodeport
```
kubectl -n argocd edit service/argocd-server
```
### command port-forward access UI
```
kubectl -n argocd port-forward deployment.apps/argocd-server 8080:8080 --address 0.0.0.0
```
### get pods on namespace argocd
```
kubectl get pods -n argocd
```
### get statefulsets 
```
kubectl get statefulsets -A
kubectl get sts -A
kubectl get statefulsets -n argocd
kubectl get sts -n argocd
```
### delete statefulsets 
```
kubectl get statefulsets -A
kubectl get sts -A
kubectl get statefulsets -n argocd
kubectl get sts -n argocd

kubectl delete sts argocd-redis-ha-server argocd-application-controller -n argocd

kubectl delete sts argocd-redis-ha-server -n argocd

kubectl delete sts argocd-application-controller -n argocd


# References
https://notes.nimtechnology.com/2021/06/20/argocd-su-dung-argocd-deploy-len-k8s/

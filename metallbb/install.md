```

https://github.com/metallb/metallb/tags

Step 1: Install MetalLB in your cluster

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml


kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


```

### Step 2: Configure it by using a configmap -> Update this with your Nodes IP range 
```
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.42.42.100-172.42.42.105

```
### Step 3: Create your service to get an external IP (would be a private IP though).
### After MetalLB installation
```
kubectl get svc -A
```

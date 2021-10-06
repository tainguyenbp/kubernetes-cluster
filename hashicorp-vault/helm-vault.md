### Step 1. 
```
helm repo add hashicorp https://helm.releases.hashicorp.com
```
### Step 1. 
```
helm search repo hashicorp/vault
```
### Step 1. 
```
helm search repo hashicorp/vault --versions
```
### Step 1. 
```
helm install vault hashicorp/vault --namespace vault --dry-run
```
### Step 1. 
```
kubectl create ns vault
```
### Step 1. 
```
helm install vault hashicorp/vault --namespace vault --version 0.16.1
```
### Step 1. 
```
helm install vault hashicorp/vault \
    --namespace vault \
    --set "server.ha.enabled=true" \
    --set "server.ha.replicas=2" \
    --dry-run
```
### Step 1. 
```

```
### Step 1. 
```

```

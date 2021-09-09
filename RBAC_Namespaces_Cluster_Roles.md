# RBAC, Namespaces and Cluster Roles
### kubectl get namespaces
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: webapp-namespace
EOF
```

### create a service account for the namespace 
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp-service-account
  namespace: webapp-namespace
EOF
```

### create a role giving us full permissions to the namespace
```
cat <<EOF | kubectl apply -f -
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: webapp-role
  namespace: webapp-namespace
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "watch"]
EOF
```

### create a role binding to tie it all together
```
cat <<EOF | kubectl apply -f -
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: webapp-role-binding
  namespace: webapp-namespace
subjects:
  - kind: ServiceAccount
    name: webapp-service-account
    namespace: webapp-namespace
roleRef:
  kind: Role
  name: webapp-role
  apiGroup: rbac.authorization.k8s.io
EOF
```
### deploy our application into our new namespace
```
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: webapp-deployment
  namespace: webapp-namespace
spec
  selector:
    matchLabels:
      app: webapp
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: scottyc/webapp:latest
        ports:
        - containerPort: 3000
          hostPort: 3000
EOF
```
###  get the secret for that service account
```
SECRET_NAME=$(kubectl get sa webapp-service-account --namespace webapp-namespace -o json | jq -r .secrets[].name)
```

###  create a ca certificate
```
kubectl get secret --namespace webapp-namespace "${SECRET_NAME}" -o json | jq -r '.data["ca.crt"]' | base64 --decode > ca.crt
```

###  get the user token from our secret
```
USER_TOKEN=$(kubectl get secret --namespace webapp-namespace "${SECRET_NAME}" -o json | jq -r '.data["token"]' | base64 --decode)
```

###  setup our kubeconfig file
```
context=$(kubectl config current-context)
CLUSTER_NAME=$(kubectl config get-contexts "$context" | awk '{print $3}' | tail -n 1)
ENDPOINT=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")
kubectl config set-cluster "${CLUSTER_NAME}" --kubeconfig=admin.conf --server="${ENDPOINT}" --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials "webapp-service-account-webapp-namespace-${CLUSTER_NAME}" --kubeconfig=admin.conf --token="${USER_TOKEN}"
kubectl config set-context "webapp-service-account-webapp-namespace-${CLUSTER_NAME}" --kubeconfig=admin.conf --cluster="${CLUSTER_NAME}" --user="webapp-service-account-webapp-namespace-${CLUSTER_NAME}" --namespace webapp-namespace
kubectl config use-context "webapp-service-account-webapp-namespace-${CLUSTER_NAME}" --kubeconfig="${KUBECFG_FILE_NAME}"

```
###  setup our kubeconfig file
```
export KUBECONFIG=admin.conf
```
###  setup our kubeconfig file
```
kubectl get pods
```
###  setup our kubeconfig file
```
kubectl get pods --namespace=webapp-namespace
```

# references:
https://www.tigera.io/blog/rbac-namespaces-and-cluster-roles/

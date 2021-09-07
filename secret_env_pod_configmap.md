# secret env pod

### create namespace test-deployapp
```
kubectl create namespace test-deployapp
```

### create deployment-app.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployapp
  namespace: test-deployapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployapp
  template:
    metadata:
      name: podapp
      labels:
        app: deployapp
    spec:
      containers:
        - name: busybox
          image: gcr.io/google_containers/busybox
          command: [ "/bin/sh", "-c", "env" ]
          envFrom:
            - secretRef:
                name: appsecret
```

### create secret-app.yaml
```
apiVersion: v1
kind: Secret
metadata:
  name: appsecret
  namespace: test-deployapp
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm   
```
### Deploy
```
kubectl apply -f deployment-app.yaml
kubectl apply -f secret-app.yaml
```


### create secret and deloyment in one file deloyment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployapp
  namespace: test-deployapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployapp
  template:
    metadata:
      name: podapp
      labels:
        app: deployapp
    spec:
      containers:
        - name: busybox
          image: gcr.io/google_containers/busybox
          command: [ "/bin/sh", "-c", "env" ]
          envFrom:
            - secretRef:
                name: appsecret
---

apiVersion: v1
kind: Secret
metadata:
  name: appsecret
  namespace: test-deployapp
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm         
```
### Deploy
```
kubectl apply -f deployment.yaml

```
### check log infor username and password
```
kubectl logs -n test-deployapp `kubectl get pods -n test-deployapp| grep "deployapp" | awk '{print $1}'`

KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=deployapp-6775c897b4-nh5kd
SHLVL=1
HOME=/root
username=admin
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
password=1f2d1e2e67df
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
PWD=/
KUBERNETES_SERVICE_HOST=10.96.0.1
```

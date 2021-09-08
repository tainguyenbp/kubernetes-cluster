# 1. secret env pod 1
### username and password
```
echo "tainguyenbp" | base64
echo "tainguyenbp@123" | base64
```

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
  username: dGFpbmd1eWVuYnAK
  password: dGFpbmd1eWVuYnBAMTIzCg==
```
### Deploy
```
kubectl apply -f deployment-app.yaml
kubectl apply -f secret-app.yaml
```
### get infor secret 
```
kubectl get secret appsecret -n test-deployapp -o yaml

echo "YWRtaW4=" | base64 --decode; echo ""
echo "MWYyZDFlMmU2N2Rm" | base64 --decode; echo ""
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
# 2. secret env pod 2
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
  username: dGFpbmd1eWVuYnAK
  password: dGFpbmd1eWVuYnBAMTIzCg==
```
### Deploy
```
kubectl apply -f deployment.yaml

```
### get infor secret 
```
kubectl get secret appsecret -n test-deployapp -o yaml

echo "YWRtaW4=" | base64 --decode; echo ""
echo "MWYyZDFlMmU2N2Rm" | base64 --decode; echo ""
```
### check log infor username and password
```
kubectl logs -n test-deployapp `kubectl get pods -n test-deployapp| grep "deployapp" | awk '{print $1}'`

KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=deployapp-6775c897b4-nh5kd
SHLVL=1
HOME=/root
username=tainguyenbp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
password=tainguyenbp@123
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT_HTTPS=443
PWD=/
KUBERNETES_SERVICE_HOST=10.96.0.1
```
# 3. secret env pod 3
### create manifest deployment-app.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginxsecretenv
  namespace: test-deployapp
data:
  username: dGFpbmd1eWVuYnAK
  password: dGFpbmd1eWVuYnBAMTIzCg==
---
apiVersion: v1
kind: Pod
metadata:
  name: deployapp
  namespace: test-deployapp
spec:
  containers:
  - name: nginx
    image: nginx
    env:
      - name: FOO_ENV_VAR
        valueFrom:
          configMapKeyRef:
            name: nginxsecretenv
            key: username
      - name: HELLO_ENV_VAR
        valueFrom:
          configMapKeyRef:
            name: nginxsecretenv
            key: password
```
### get infor secret 1
```
kubectl get configmap nginxsecretenv -n test-deployapp -o yaml
```
### get infor secret 2
```
kubectl -n test-deployapp exec deployapp -it -- env | grep _ENV_
```


# 4. secret env pod 4
## envVar
### create manifest deployment-app.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: configsecret
  namespace: test-deployapp
data:
  USERNAME: dGFpbmd1eWVuYnAK
  PASSWORD: dGFpbmd1eWVuYnBAMTIzCg==
---
apiVersion: v1
kind: Pod
metadata:
  name: deployapp
  namespace: test-deployapp
spec:
  containers:
  - name: nginx
    image: nginx
    envFrom:
      - configMapRef:
         name: configsecret
```
### get infor secret 1
```
kubectl get configmap -n test-deployapp
kubectl get configmap configsecret -n test-deployapp -o yaml
```
### get infor secret 2
```
kubectl get pods -n test-deployapp
kubectl -n test-deployapp exec deployapp -it -- env | grep _ENV_
```

# 5. secret env pod 4
## envVar
### create manifest deployment-app.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployapp
  namespace: test-deployapp
spec:
  selector:
    matchLabels:
      app: deployapp
  replicas: 1
  template:
    metadata:
      labels:
        app: deployapp
    spec:
      volumes:
        - name: config-data-volume
          configMap:
            name: app-config
      containers:
      - name: testapp
        image: testapp
        volumeMounts:
        - mountPath: /config
          name: config-data-volume
```  

# Reference:
```
https://cloudfun.vn/threads/tim-hieu-cach-dinh-cau-hinh-ung-dung-kubernetes-bang-configmap.399/
```

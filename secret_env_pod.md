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
                name: app_secret
```

### create secret-app.yaml
```
apiVersion: v1
kind: Secret
metadata:
  name: app_secret
  namespace: test-deployapp
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm   
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
                name: app_secret
---

apiVersion: v1
kind: Secret
metadata:
  name: app_secret
  namespace: test-deployapp
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm         
```

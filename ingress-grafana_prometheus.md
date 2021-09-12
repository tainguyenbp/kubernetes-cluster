### ingress-grafana.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-grafana
  namespace: prom-monitoring 
spec:
  defaultBackend:
    service:
      name: prometheus-grafana
      port:
        number: 80
  rules:
  - host: grafana.tainn.it
    http:
      paths:
      - path: /*
        pathType: ImplementationSpecific
        backend:
          service:
            name: prometheus-grafana
            port: 
              number: 80
  ingressClassName: nginx
---
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: ingress-grafana
  namespace: prom-monitoring 
spec:
  controller: k8s.io/ingress-nginx
```
### ingress-prometheus.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-prometheus
  namespace: prom-monitoring 
spec:
  rules:
  - host: prometheus.tainn.it
    http:
      paths:
      - path: /prometheus
        pathType: Prefix
        backend:
          service:
            name: prometheus-kube-prometheus-prometheus
            port: 
              number: 9090
  ingressClassName: nginx
---
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: ingress-prometheus
  namespace: prom-monitoring 
spec:
  controller: k8s.io/ingress-nginx
```
### ingress-alertmanager.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-alertmanager
  namespace: prom-monitoring 
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.class: "nginx"
spec:
  defaultBackend:
    service:
      name: prometheus-kube-prometheus-alertmanager
      port:
        number: 9093
  tls:
  - hosts:
    - alertmanager.tainn.it
    secretName: alertmanager-tls
  rules:
  - host: alertmanager.tainn.it
    http:
      paths:
      - path: /alertmanager
        pathType: Prefix
        backend:
          service:
            name: prometheus-kube-prometheus-alertmanager
            port:
              number: 9093
---
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  namespace: prom-monitoring 
spec:
  controller: k8s.io/ingress-nginx
```

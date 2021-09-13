
### Reference:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/baremetal/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/baremetal/deploy.yaml
```

### Reference:
```
kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --watch
kubectl describe service -n ingress-nginx ingress-nginx-controller
```

### helm:
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create ns ingress-nginx
helm install ingress-nginx -n ingress-nginx ingress-nginx/ingress-nginx
```
### add ip ingress-nginx-controller:
```
  externalIPs:
  - 192.168.0.10
  - 192.168.0.10
```
### template:
```
NAME: ingress-nginx
LAST DEPLOYED: Sun Sep 12 18:04:17 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace default get services -o wide -w ingress-nginx-controller'

An example Ingress that makes use of the controller:

  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class:
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
```


### Reference:
```

```

### Reference:
```

```

### Reference:
```

```

### Reference:
```

```

# Reference:
```
https://platform9.com/blog/building-a-complete-stack-ingress-controllers/
https://platform9.com/docs/kubernetes/tutorials-setup-kubernetes-ingress
https://kubernetes.github.io/ingress-nginx/deploy/
https://xuanthulab.net/trien-khai-nginx-ingress-controller-trong-kubernetes.html
https://viblo.asia/p/su-dung-kubernetes-ingress-nginx-ingress-controller-de-dinh-tuyen-nhieu-service-khac-nhau-L4x5x8Gg5BM
https://www.itblognote.com/2021/04/how-to-install-nginx-ingress-cert-manager-kubernetes.html
https://nvtienanh.info/devops/cai-ingress-nginx-tren-kubernetes-on-premise-20210113/
https://www.ovh.com/blog/getting-external-traffic-into-kubernetes-clusterip-nodeport-loadbalancer-and-ingress/
https://lazyadmin.info/setup-ingress-tren-kubernetes-bang-nginx-controller/
https://medium.com/m/global-identity?redirectUrl=https%3A%2F%2Fitnext.io%2Fbare-metal-kubernetes-with-kubeadm-nginx-ingress-controller-and-haproxy-bb0a7ef29d4e
```

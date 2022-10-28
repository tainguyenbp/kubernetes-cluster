# example 1
```
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: example-vs
spec:
  gateways:
  - istio-system/public
  hosts:
  - example.dev
  http:
  - name: slash
    match: 
    - uri: 
        prefix: /
    route:
    - destination:
        port: 
          number: 9898
        host: example-svc.podinfo.svc.cluster.local
  - name: slash-api
    match: 
    - uri: 
        prefix: /api
    route:
    - destination:
        port: 
          number: 9898
        host: example-svc.podinfo.svc.cluster.local
```

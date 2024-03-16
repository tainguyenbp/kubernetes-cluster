# setup-sso-argocd-github.md

### sso-argocd-github-client-secret.yaml
```
## add secret to SSO
apiVersion: v1
kind: Secret
metadata:
  name: github-client-secret
  namespace: argocd
  labels:
    app.kubernetes.io/part-of: argocd
type: Opaque
data:
  dex.github.clientSecret: QXBwbGljYXRpb24gcmVjb25jaWxpYXRpb24gdGltZW91dCBpcyB0aGUgbWF4IGFtb3VudCBvZiB0aW1lIHJlcXVpcmVkIHRvIGRpc2NvdmVyIGlmIGEgbmV3IG1hbmlmZXN0cyB2ZXJzaW9uIGdvdA== # gen clientSecret and encode clientSecret
```

### sso-argocd-github-configmap.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cm
  namespace: argocd
data:
  admin.enabled: "false"

  # disables user. User is enabled by default
  #accounts.alice.enabled: "false"
  #accounts.test-user.enabled: "false"

  # Application reconciliation timeout is the max amount of time required to discover if a new manifests version got
  # published to the repository. Reconciliation by timeout is disabled if timeout is set to 0. Three minutes by default.
  # > Note: argocd-repo-server deployment must be manually restarted after changing the setting.
  timeout.reconciliation: 180s

  configManagementPlugins: |
    - name: argocd-vault-plugin
      generate:
        command: ["argocd-vault-plugin"]
        args: ["generate", "./"]
    - name: argocd-vault-plugin-kustomize
      generate:
        command: ["sh", "-c"]
        args: ["kustomize build . > all.yaml && argocd-vault-plugin generate all.yaml"]
    - name: argocd-vault-plugin-helm
      generate:
        command: ["sh", "-c"]
        args: ["helm template $ARGOCD_APP_NAME ${helm_args} . | argocd-vault-plugin generate -"]

### enable SSO with GitHub OAuth2
  url: https://tainguyenbp-argocd.onpoint.vn
  dex.config: |
    connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: 1234567890
          clientSecret: $github-client-secret:dex.github.clientSecret
          orgs:
          - name: tainguyenbp    # Name of the organization in Github
            teams:           # The list of authorized teams (optional)
            - SRE

```

### ingress-nginx-argocd.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd.hotromaytinhit.tech
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: nginx
    alb.ingress.kubernetes.io/ssl-passthrough: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    ingress.kubernetes.io/configuration-snippet: "gzip on;\ngzip_comp_level 5;\ngzip_http_version 1.1;\ngzip_min_length 16;\ngzip_proxied no_etag"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "1024k"
    nginx.ingress.kubernetes.io/large-client-header-buffers: "64 2048k"
    nginx.ingress.kubernetes.io/proxy-body-size: "30m"
    nginx.ingress.kubernetes.io/client-body-buffer-size: "2m"
spec:
  rules:
    - host: argocd.hotromaytinhit.tech
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 8080
```

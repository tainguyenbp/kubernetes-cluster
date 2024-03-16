# setup-sso-argocd-github.md

sso-argocd-github-client-secret.yaml
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


# sso-argocd-github-configmap.yaml
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

```

helm repo add gitlab https://charts.gitlab.io/

helm repo update

helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=gitlab.tainn.local \
  --set global.hosts.externalIP=192.168.1.1 \
  --set certmanager-issuer.email=gitlab@tainn.local
 
 
```

Initial login
```

```

# Reference:
```
https://docs.gitlab.com/charts/installation/deployment.html
https://blog.dbi-services.com/deploy-gitlab-on-kubernetes-using-helm/
https://blog.lwolf.org/post/fully-automated-gitlab-installation-on-kubernetes-including-runner-and-registry/
https://blog.lwolf.org/post/how-to-easily-deploy-gitlab-on-kubernetes/
```

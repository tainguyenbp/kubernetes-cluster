# 1. scripts cancel job github action in the main branch
### cancel-job-gha.sh

```
#!/bin/bash

token=ghp_123456789
repo=tainguyenbp/kubernetes-cluster
branch_name='main'

ids=$(curl -s -H "Authorization: token $token" \
    https://api.github.com/repos/$repo/actions/runs?branch=${branch_name} | \
    jq '.workflow_runs[] | select([.status] | inside(["in_progress", "queued"])) | .id')

set -- $ids

for i; do curl \
    -H "Authorization: token ${token}" \
    -X POST "https://api.github.com/repos/${repo}/actions/runs/${i}/cancel"; done
```
# 2. Install github action seft-hosted in the k8s, eks, azure
### 2.1. Install github action seft-hosted in the k8s, eks, azure
```
# gen github_token of the organization or the personal

helm upgrade --install --namespace actions --create-namespace --set=authSecret.create=true \
    --set=authSecret.github_token="ghp_123456789" \
    --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
    --values values-gha.yaml

helm upgrade --install --namespace actions --create-namespace --set=authSecret.create=true \
    --set=authSecret.github_token="ghp_123456789" \
    --wait actions-runner-controller actions-runner-controller/actions-runner-controller
```
### 2.2. Install github action seft-hosted in the k8s, eks, azure
```

```

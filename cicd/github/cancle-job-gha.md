# cancel job github action in the main branch

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

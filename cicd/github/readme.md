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
### 2.2. Dockerfile.aws
```
# docker build -t tainguyenbp/action-runner:v1.2.5 .

FROM summerwind/actions-runner:latest

WORKDIR /tmp/

RUN curl -L -o install-aws.sh https://raw.githubusercontent.com/unfor19/install-aws-cli-action/master/entrypoint.sh && \
    sudo chmod +x install-aws.sh && \
    sudo ./install-aws.sh "v2" "amd64" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/kubectl && \
    sudo rm -rf install-aws.sh

```
### 2.3. Dockerfile.golang
```
# docker build -t tainguyenbp/action-runner:v1.2.5 .

FROM summerwind/actions-runner:latest

# This will be a good place to add your CA bundle if you're using
# a custom CA.

# If you have proxy configurations, you can also add them here

# Change the work dir to tmp because these are disposable files
WORKDIR /tmp

# Install a stable version of Go
# and verify checksum of the tarball
# 
# Go releases URL: https://go.dev/dl/
#
RUN curl -OL https://go.dev/dl/go1.17.6.linux-amd64.tar.gz && \
    echo "231654bbf2dab3d86c1619ce799e77b03d96f9b50770297c8f4dff8836fc8ca2  go1.17.6.linux-amd64.tar.gz" | sha256sum -c - && \
    sudo tar -C /usr/local -xvf go1.17.6.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /home/runner/.bashrc

# Sanity check
RUN export PATH=$PATH:/usr/local/go/bin && \
    go version

```
### 2.3. runner-deployment-org
```

apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runner-deployment-org
  namespace: gha-actions
spec:
  template:
    spec:
      # env:
      # - name: DOCKER_BUILDKIT
      #   value: "1"
      nodeSelector:
        alpha.eksctl.io/nodegroup-name: managed-eks-gha-node
        env: CICD-GHA
      organization: tainguyenbp
      image: tainguyenbp/action-runner:v1.2.5
      dockerdContainerResources:
        requests:
          cpu: 500m
          memory: 2048Mi

---
apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: runner-deployment-org
  namespace: gha-actions
spec:
  scaleTargetRef:
    name: runner-deployment-org
  # scheduledOverrides:
  # # Set minReplicas to 0 on sat
  # - schedule: "0 23 * * *"
  #   minReplicas: 0
  # # Set minReplicas back to 1 on mon
  # - schedule: "0 7 * * *"
  #   minReplicas: 1
  minReplicas: 2
  maxReplicas: 40
  scaleDownDelaySecondsAfterScaleOut: 120
  metrics:
    - type: PercentageRunnersBusy
      scaleUpThreshold: '0.6'
      scaleDownThreshold: '0.4'
      scaleUpFactor: '1.3'
      scaleDownFactor: '0.7'

# apiVersion: actions.summerwind.dev/v1alpha1
# kind: HorizontalRunnerAutoscaler
# metadata:
#   annotations:
#   name: runner-deployment-org
#   namespace: actions
# spec:
#   maxReplicas: 100
#   metrics:
#   - scaleDownFactor: "0.7"
#     scaleDownThreshold: "0.3"
#     scaleUpFactor: "1.4"
#     scaleUpThreshold: "0.7"
#     type: PercentageRunnersBusy
#   minReplicas: 5
#   scaleDownDelaySecondsAfterScaleOut: 120
#   scaleTargetRef:
#     name: runner-deployment-org

  # metrics:
  # - type: PercentageRunnersBusy
  #    scaleType: step
  #    scaleUpThreshold: '0.75'     # required both step scaling and percentage scaling
  #    scaleDownThreshold: '0.3'  # required both step scaling and percentage scaling
  #    scaleUpValue: '2'                 # required both step scaling and percentage scaling
  #    scaleDownValue: '1' 

  # metrics:
  # - type: TotalNumberOfQueuedAndInProgressWorkflowRuns
  #    scaleType: step
  #    scaleUpValue: '2'         # required for step scaling, not required for queue depth scaling
  #    scaleDownValue: '1'     # required for step scaling, not required for queue depth scaling

```

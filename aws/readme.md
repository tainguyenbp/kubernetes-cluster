# I karpenter
### 1.1. Value file for the Karpenter
### values-karpenter-v0.32.7.yaml
```
additionalAnnotations: {}
additionalClusterRoleRules: []
additionalLabels: {}
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: karpenter.sh/provisioner-name
          operator: DoesNotExist
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels:
          app.kubernetes.io/instance: karpenter
          app.kubernetes.io/name: karpenter
      topologyKey: kubernetes.io/hostname
aws:
  defaultInstanceProfile: KarpenterNodeInstanceProfile
clusterEndpoint: https://1234567890987654321.gr1.us-east-2.eks.amazonaws.com
clusterName: eks-tainn-sre
controller:
  env: []
  envFrom: []
  errorOutputPaths:
  - stderr
  extraVolumeMounts: []
  healthProbe:
    port: 8081
  image:
    # # -- Repository path to the controller image.
    # repository: public.ecr.aws/karpenter/controller
    # # -- Tag of the controller image.
    # tag: v0.29.2
    # # -- SHA256 digest of the controller image.
    # digest: sha256:bac5ea470c09df21eb3742cf9448e9b806138ed5b6321d4e04697bbdf122eac6
    # -- Repository path to the controller image.
    repository: public.ecr.aws/karpenter/controller
    # -- Tag of the controller image.
    tag: v0.32.7
    # -- SHA256 digest of the controller image.
    digest: sha256:afa0d0fd5ac375859dc3d239ec992f197cdf01f6c8e3413e3845a43c2434621e
  logEncoding: ""
  logLevel: "debug"
  metrics:
    port: 8080
  outputPaths:
  - stdout
  resources: {}
  securityContext: {}
  sidecarContainer: []
  sidecarVolumeMounts: []
dnsConfig: {}
dnsPolicy: Default
extraObjects: []
extraVolumes: []
fullnameOverride: ""
hostNetwork: false
imagePullPolicy: IfNotPresent
imagePullSecrets: []
logEncoding: console
logLevel: debug
nameOverride: ""
nodeSelector:
  kubernetes.io/os: linux
  env: SRE-Prod
podAnnotations: {}
podDisruptionBudget:
  maxUnavailable: 1
  name: karpenter
podLabels: {}
podSecurityContext:
  fsGroup: 1000
priorityClassName: system-cluster-critical
replicas: 2
revisionHistoryLimit: 10
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789:role/eksctl-eks-tainn-sre-iamservice-role
  create: true
  name: karpenter
serviceMonitor:
  additionalLabels: {}
  enabled: false
  endpointConfig: {}
settings:
  aws:
    clusterEndpoint: https://1234567890987654321.gr1.us-east-2.eks.amazonaws.com
    clusterName: eks-tainn-sre
    defaultInstanceProfile: KarpenterNodeInstanceProfile
    enableENILimitedPodDensity: true
    enablePodENI: false
    interruptionQueueName: eks-tainn-sre
    isolatedVPC: false
    nodeNameConvention: ip-name
    tags: null
    vmMemoryOverheadPercent: 0.075
  batchIdleDuration: 1s
  batchMaxDuration: 10s
  featureGates:
    driftEnabled: false
strategy:
  rollingUpdate:
    maxUnavailable: 1
terminationGracePeriodSeconds: null
tolerations:
- key: CriticalAddonsOnly
  operator: Exists
topologySpreadConstraints:
- labelSelector:
    matchLabels:
      app.kubernetes.io/instance: karpenter
      app.kubernetes.io/name: karpenter
  maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
webhook:
  logLevel: debug
  port: 8443

```
### 1.2. Install Karpenter
```
helm upgrade --install --namespace karpenter \
  --create-namespace karpenter oci://public.ecr.aws/karpenter/karpenter \
  --version v0.32.7 \
  --values values-karpenter-v0.32.7.yaml \
  --wait
```
### 1.3. Install Karpenter
### provisioner-eks-tainn-sre.yaml
```
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: eks-tainn-sre
spec:
  consolidation:
    enabled: false
  labels:
    alpha.eksctl.io/nodegroup-name: managed-eks-gha-node
    env: CICD-GHA
  limits:
    resources:
      cpu: "60"
  providerRef:
    name: eks-tainn-sre-provider
  requirements:
  - key: kubernetes.io/os
    operator: In
    values:
    - linux
  - key: kubernetes.io/arch
    operator: In
    values:
    - amd64
  - key: karpenter.sh/capacity-type
    operator: In
    values:
    - spot
  - key: karpenter.k8s.aws/instance-family
    operator: In
    values:
    - t3
    - t3a
  - key: karpenter.k8s.aws/instance-size
    operator: In
    values:
    - 2xlarge
  ttlSecondsAfterEmpty: 60
  ttlSecondsUntilExpired: 2592000

```
### 1.4. Install Karpenter
### awsnodetemplate-eks-tainn-sre.yaml
```
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: eks-tainn-sre-provider
spec:
  blockDeviceMappings:
  - deviceName: /dev/xvda
    ebs:
      deleteOnTermination: true
      iops: 3000
      throughput: 200
      volumeSize: 50Gi
      volumeType: gp3
  securityGroupSelector:
    karpenter.sh/discovery: eks-tainn-sre
  subnetSelector:
    karpenter.sh/discovery: eks-tainn-sre
  tags:
    alpha.eksctl.io/nodegroup-name: managed-eks-gha-node
    env: CICD-GHA
  userData: |
    #!/bin/bash
    echo 'ssh-rsa ssh key tainguyenbp-sre' >> /home/ec2-user/.ssh/authorized_keys
    chmod 600 /home/ec2-user/.ssh/authorized_keys
status:
  securityGroups:
  - id: sg-sg1234567890
  - id: sg-sg0987654321
  subnets:
  - id: subnet-12345678902c
    zone: us-east-2c
  - id: subnet-09876543212b
    zone: us-east-2b
  - id: subnet-09876543212a
    zone: us-east-2a
```

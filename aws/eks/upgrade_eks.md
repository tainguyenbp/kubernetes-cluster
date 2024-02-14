### update eks cluster version: "1.28" to version: "1.29"
```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
# eksctl upgrade cluster --name=eks-devopsdevops --version=1.29
metadata:
  name: eks-devops
  region: ap-southeast-1
  version: "1.29"
  tags:
    karpenter.sh/discovery: eks-devops

iam:
  withOIDC: true

karpenter:
  version: 'v0.32.3'
  createServiceAccount: true # default is false
  defaultInstanceProfile: 'KarpenterNodeInstanceProfile-eks-devops' # default is to use the IAM instance profile created by eksctl
  withSpotInterruptionQueue: true # adds all required policies and rules for supporting Spot Interruption Queue, default is false

kubernetesNetworkConfig:
  ipFamily: IPv4
  serviceIPv4CIDR: 10.103.0.0/16

privateCluster:
  enabled: true
  skipEndpointCreation: true

vpc:
  id: "vpc-123456789"
  subnets:
    # public:
      # ap-southeast-1a: { id: subnet-123 }
      # ap-southeast-1b: { id: subnet-456 }
      # ap-southeast-1c: { id: subnet-789 }
    private:
      ap-southeast-1a: { id: subnet-987 }
      ap-southeast-1b: { id: subnet-654 }
      ap-southeast-1c: { id: subnet-321 }

addons:
# - name: vpc-cni # no version is specified so it deploys the default version
#   attachPolicyARNs:
#     - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
# - name: coredns
#   version: latest # auto discovers the latest available
# - name: kube-proxy
#   version: latest
- name: aws-ebs-csi-driver
  wellKnownPolicies:      # add IAM and service account
    ebsCSIController: true

managedNodeGroups:
  - name: managed-ng-tainnsre-ondemand01
    instanceTypes: ["t3a.xlarge","t3.xlarge"]
    minSize: 1
    desiredCapacity: 1
    maxSize: 2
    volumeSize: 30
    volumeType: gp3
    availabilityZones: ["ap-southeast-1a", "ap-southeast-1b","ap-southeast-1c"]
    updateConfig:
      maxUnavailable: 1
    iam:
      withAddonPolicies:
        autoScaler: true
    labels:
      node-class: "worker-node"
      type_node_pool: ondemand
      environments: prod
    tags:
      nodegroup-role: worker
      type_node_pool: ondemand
      alpha.eksctl.io/nodegroup-name: managed-ng-tainnsre-ondemand01
      k8s.io/cluster-autoscaler/enabled: "true"
      k8s.io/cluster-autoscaler/eks-devops: "owned"
    ssh:
      allow: true
      publicKeyName: tainnsre
    privateNetworking: true

```

### upgrade cluster eks-devops with version eks 1.29
```
eksctl upgrade cluster --config-file=cluster-config.yaml
eksctl upgrade cluster --config-file cluster-config.yaml --approve
```

### upgrade node group eks-devops with version eks 1.29
```
eksctl upgrade nodegroup --name  managed-ng-tainnsre-ondemand01 \
--cluster=eksdevops \
--region=ap-southeast-1 \
--kubernetes-version=1.29
```

### upgrade node karpenter eks-devops
```
eksctl upgrade nodegroup --name  managed-ng-tainnsre-ondemand01 \
--cluster=eksdevops \
--region=ap-southeast-1 \
--kubernetes-version=1.29
```


### upgrade version add-on in th eks-devops

```
eksctl utils update-kube-proxy --cluster=eks-devops --approve
eksctl utils update-aws-node --cluster=eks-devops --approve
eksctl utils update-coredns --cluster=eks-devops --approve
```


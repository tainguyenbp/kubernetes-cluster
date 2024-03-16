# install ingress nginx in the eks cluster
# eks-cluster with 3 subnet private -> tag kubernetes.io/role/internal-elb 1
# ingress nginx install in the subnet public -> tag subnet kubernetes.io/role/elb 1
```

kubernetes.io/role/internal-elb                Set to 1 or empty tag value for internal load balancers
kubernetes.io/role/elb                         Set to 1 or empty tag
kubernetes.io/role/internal-elb 1
kubernetes.io/role/elb 1
```


# terraform with teraform module eks cluster.
```
.
|-- .github
|   |-- workflows
|   |   |-- apply-all-tf-infra.yaml
|   |   |-- apply-tf-infra.yaml
|   |   |-- destroy-tf-infra.yaml
|   |   |-- manual-apply-tf-infra.yaml
|   |   |-- plan-tf-infra.yaml
|   |   |-- stack-tf-infra.yaml
|   |   `-- uninstall-tf-infra.yaml
|-- README.md
|-- environments
|   |-- local
|       |-- backend.tf
|       |-- main.tf
|       |-- outputs.tf
|       |-- providers.tf
|       |-- s3-dynamodb
|       |   -- main.tf
|       |-- variables.tf
|   |-- dev
|       |-- backend.tf
|       |-- main.tf
|       |-- outputs.tf
|       |-- providers.tf
|       |-- s3-dynamodb
|       |   -- main.tf
|       |-- variables.tf
|   |-- stg
|       |-- backend.tf
|       |-- main.tf
|       |-- outputs.tf
|       |-- providers.tf
|       |-- s3-dynamodb
|       |   -- main.tf
|       |-- variables.tf
|   |-- prod
|       |-- backend.tf
|       |-- main.tf
|       |-- outputs.tf
|       |-- providers.tf
|       |-- s3-dynamodb
|       |   -- main.tf
|       |-- variables.tf
|-- infra
|   |-- backend
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   `-- variables.tf
|   |-- eks-fargate-karpenter
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   `-- variables.tf
|   |-- rds
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   `-- variables.tf
|   `-- vpc
|       |-- main.tf
|       |-- outputs.tf
|       `-- variables.tf
|-- stack
|   |-- istio
|   |   |-- istio-ingress.yaml
|   |   |-- istiod-values.yaml
|   |   |-- pod-monitor.yaml
|   |   `-- service-monitor.yaml
|   |-- keda
|   |   `-- values.yaml
|   |-- metabase
|   |   |-- metabase-hpa.yaml
|   |   |-- metabase-scaling-dashboard.yaml
|   |   `-- values.yaml
|   `-- monitoring
|       `-- values.yaml
```

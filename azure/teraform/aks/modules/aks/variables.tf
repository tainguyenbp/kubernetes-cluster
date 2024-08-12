variable "aks" {
  description = "AKS configurations"
  type = object({
    cluster_name               = string
    cluster_version            = string
    master_resource_group_name = string
    worker_resource_group_name = string
  })
}

variable "location" {
  type        = string
  description = "Region where AKS will be deployed"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = string
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "acr_id" {
  type        = string
  description = "ACR ID"
}

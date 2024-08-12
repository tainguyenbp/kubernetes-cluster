variable "resource_group_name" {
  type        = string
  description = "ACR resource group name"
}

variable "location" {
  type        = string
  description = "Region where ACR will be deployed"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "acr_name" {
  type        = string
  description = "ACR Name"
}

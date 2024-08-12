locals {
  environment                       = "testing"
  region                            = "eastus"
  control_plain_resource_group_name = "${local.environment}-${local.region}-control-plain"
  acr_resource_group_name           = "acr"
  vnet_name           = "network"
  resource_group_name = "${local.environment}-${local.region}-control-plain"

  aks = {
    master_resource_group_name = data.azurerm_resource_group.resource-group.name
    worker_resource_group_name = "${local.environment}-${local.region}-worker"
    cluster_name               = "${local.environment}-${local.region}-aks-cluster"
    cluster_version            = "1.29"
  }
  resource_group_name = "acr"
  repositories        = ["testingeastusacr"]
  repositories_map    = { for repo in local.repositories : repo => repo }
}

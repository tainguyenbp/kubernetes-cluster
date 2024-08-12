module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.1.0"

  resource_group_name = var.aks.master_resource_group_name
  cluster_name        = var.aks.cluster_name
  kubernetes_version  = var.aks.cluster_version
  location            = var.location
  prefix              = "aks"
  
  agents_availability_zones       = lookup(var.aks, "agents_availability_zones", ["1", "2", "3"])
  agents_count                    = 2
  agents_min_count                = lookup(var.aks, "agents_min_count", 1)
  agents_max_count                = lookup(var.aks, "agents_max_count", 4)
  agents_max_pods                 = lookup(var.aks, "agents_max_pods", 40)
  agents_pool_max_surge           = lookup(var.aks, "agents_pool_max_surge", "2")
  agents_size                     = lookup(var.aks, "agents_size", "Standard_DS2_v2")
  agents_type                     = "VirtualMachineScaleSets"
  network_plugin                  = "azure"
  node_os_channel_upgrade         = "NodeImage"
  node_resource_group             = var.aks.worker_resource_group_name
  oidc_issuer_enabled             = true
  os_sku                          = "Ubuntu"
  sku_tier                        = "Standard"
  vnet_subnet_id                  = var.subnet_ids
  log_analytics_workspace_enabled = false
  rbac_aad                        = false
  workload_identity_enabled       = true

  tags = {
    environment = var.environment
    name        = lower("${var.environment}-${var.location}-cluster")
  }
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  principal_id                     = module.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

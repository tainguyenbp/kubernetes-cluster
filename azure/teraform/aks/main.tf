data "azurerm_resource_group" "resource-group" {
  name = local.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = "${local.environment}-${local.region}-${local.vnet_name}"
  resource_group_name = local.resource_group_name
}

data "azurerm_subnet" "private_subnet" {
  name                 = "${local.environment}-${local.region}-app-private-subnet-1"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = local.resource_group_name
}

data "azurerm_container_registry" "container_registry" {
  name                = "sandboxeastusacr"
  resource_group_name = "acr"
}

module "control_plain_resource_group" {
  source = "../../../../modules/resource-group"

  location = local.region
  rg_name  = local.control_plain_resource_group_name
}

module "acr_resource_group" {
  source = "../../../../modules/resource-group"

  location = local.region
  rg_name  = local.acr_resource_group_name
}

module "acr" {
  for_each = local.repositories_map
  source   = "../../../../modules/acr"

  resource_group_name = data.azurerm_resource_group.resource-group.name
  location            = local.region
  environment         = local.environment
  acr_name            = each.value
}

module "aks" {
  source      = "../../../../modules/aks"
  environment = local.environment
  aks         = local.aks
  location    = local.region
  subnet_ids  = data.azurerm_subnet.private_subnet.id
  acr_id      = data.azurerm_container_registry.container_registry.id
}

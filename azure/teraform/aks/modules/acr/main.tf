module "acr" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "0.1.0"

  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  enable_telemetry              = false
  location                      = var.location
  admin_enabled                 = true

  tags = {
    environment = var.environment
    name        = lower("${var.environment}-${var.location}-registry")
  }
}

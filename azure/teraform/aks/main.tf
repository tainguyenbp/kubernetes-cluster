locals {
  default_tags = {}
  all_tags     = merge(local.default_tags, var.tags)
}

resource "azurerm_resource_group" "az-rg" {
  name     = var.rg_name
  location = var.location

  tags = local.all_tags
}

terraform {
  backend "azurerm" {
    resource_group_name  = "azure-terraform-group"
    storage_account_name = "terraformazurestate"
    container_name       = "tainnsre-tainguyenbp"
    key                  = "tainnsre-testing.terraform.tfstate"
  }
}

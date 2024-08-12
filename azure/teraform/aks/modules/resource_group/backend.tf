terraform {
  backend "azurerm" {
    resource_group_name  = "azure-terraform-group"
    storage_account_name = "terraformazurestate"
    container_name       = "testing-eastus"
    key                  = "testing-eastus-testing.terraform.tfstate"
  }
}

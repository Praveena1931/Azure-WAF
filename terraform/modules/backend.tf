terraform {
  backend "azurerm" {
    resource_group_name  = "waf-rg"
    storage_account_name = "tfstateacct"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

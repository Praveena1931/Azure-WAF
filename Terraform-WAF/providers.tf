terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

 #required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = "7f16aeca-0ad0-4844-845d-fad64868f677"
}

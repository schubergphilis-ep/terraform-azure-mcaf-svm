terraform {
  required_version = "~> 1.9"

  required_providers {
    restful = {
      source  = "magodo/restful"
      version = "0.14.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

provider "restful" {
  base_url = ""
}

provider "azapi" {
}

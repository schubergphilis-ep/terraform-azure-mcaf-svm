terraform {
  required_version = "~> 1.15"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.3"
    }
  }
}

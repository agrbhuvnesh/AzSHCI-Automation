provider "azurerm" {
#   version = "=3.55.0"
  features {}
  skip_provider_registration = "true"
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

terraform {
  backend "azurerm" {
  }
}
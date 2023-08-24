provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azapi" {
}

# Variables
variable "clusterResourceIds" {
  type        = list(string)
  description = "Resource Ids of the Azure Stack HCI clusters to install the Azure Monitoring Agent extension."
}

variable "port" {
  type        = string
  description = "Port number to be used for the Admin Center extension."
}

variable "azStackHCIApiVersion" {
  type        = string
  description = "The Azure Stack HCI Cluster api version to be used with azapi_resource"
}

# locals
locals {
  adminCenterExtensionName = "AdminCenter"
  publisher                = "Microsoft.AdminCenter"
}

# Existing Azure Stack HCI Clusters
data "azapi_resource" "cluster" {
  for_each    = toset(var.clusterResourceIds)
  type        = "Microsoft.AzureStackHCI/clusters@${var.azStackHCIApiVersion}"
  resource_id = each.value
}

# Azure Stack HCI cluster extensions
resource "azapi_resource" "azurestackhci_cluster_extension" {
  for_each  = toset(var.clusterResourceIds)
  type      = "microsoft.azurestackhci/clusters/arcsettings/extensions@${var.azStackHCIApiVersion}"
  name      = local.adminCenterExtensionName
  parent_id = "${data.azapi_resource.cluster[each.key].id}/arcSettings/default"
  body = jsonencode({
    properties = {
      extensionParameters = {

        publisher               = local.publisher
        type                    = local.adminCenterExtensionName
        autoUpgradeMinorVersion = false
        enableAutomaticUpgrade  = true
        settings = {
          port = var.port
        }
      }
    }
  })
}

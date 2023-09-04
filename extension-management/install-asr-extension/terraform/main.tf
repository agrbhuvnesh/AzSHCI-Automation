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

variable "azStackHCIApiVersion" {
  type        = string
  description = "The Azure Stack HCI Cluster api version to be used with azapi_resource"
}

variable "clusterResourceIds" {
  type        = list(string)
  description = "Resource Ids of the Azure Stack HCI clusters to install the Azure Monitoring Agent extension."
}

variable "recoverySiteId" {
  type        = string
  description = "SiteId of the recovery vault to be used while installing extension."
}

variable "recoverySiteName" {
  type        = string
  description = "Name of the recovery site to be used while installing extension."
}

variable "recoveryServicesVaultName" {
  type        = string
  description = "Name of the Recovery Services Vault."
}

variable "recoveryServicesVaultResourceGroup" {
  type        = string
  description = "Resource Group of the Recovery Vault."
}

variable "recoveryServicesVaultLocation" {
  type        = string
  description = "Location of the Recovery Vault."
}

variable "privateEndpointStateForSiteRecovery" {
  type        = string
  default     = "None"
  description = "Private endpoint state for site recovery. Allowed values: None, Pending, Approved, Rejected, Disconnected, Timeout, Ready, or Unknown."
}

# locals
locals {
  ASRExtensionName       = "ASRExtension"
  publisher              = "Microsoft.SiteRecovery.Dra"
  type                   = "Windows"
  environment            = "AzureCloud"

}

# Data sources
# Get the current subscription id
data "azurerm_subscription" "current" {
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
  name      = local.ASRExtensionName
  parent_id = "${data.azapi_resource.cluster[each.key].id}/arcSettings/default"
  body = jsonencode({
    properties = {
      extensionParameters = {
        publisher = local.publisher
        type      = local.type
        autoUpgradeMinorVersion = false
        enableAutomaticUpgrade = true
        settings = {
          SubscriptionId = data.azurerm_subscription.current.subscription_id
          Environment    = local.environment
          ResourceGroup  = var.recoveryServicesVaultResourceGroup
          ResourceName   = var.recoveryServicesVaultName
          Location       = var.recoveryServicesVaultLocation
          SiteId         = var.recoverySiteId
          SiteName       = var.recoverySiteName
          PrivateEndpointStateForSiteRecovery = var.privateEndpointStateForSiteRecovery
        }
        protectedSettings = {}
      }
    }
  })
}